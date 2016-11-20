# -*- coding: utf-8 -*-

import httplib
import threading
import os

from bottle import HTTPError, request, HTTPResponse, response
import bottle

from pybot.youpi2.http.base import YoupiBottleApp
from pybot.youpi2.http.__version__ import version

__author__ = 'Eric Pascual'


bottle.DEBUG = True


class RestAPIApp(YoupiBottleApp):
    """ REST API for controlling the arm.
    """
    SAVED_WORKSPACE_FILE = 'workspace.xml'
    STORAGE_PATH = "/var/lib/youpi2-gprog"

    app_title = ''

    def __init__(self, *args, **kwargs):
        super(RestAPIApp, self).__init__(*args, **kwargs)

        self._wksp_save_path = os.path.join(self.STORAGE_PATH, self.SAVED_WORKSPACE_FILE)
        if not os.path.isdir(self.STORAGE_PATH):
            os.makedirs(self.STORAGE_PATH)

        self.runner = None
        self._terminate_event = threading.Event()
        self._run_status = 'idle'

        self.route('/run', 'POST', callback=self.run_program)
        self.route('/abort', 'POST', callback=self.abort_execution)
        self.route('/status', 'GET', callback=self.get_status)
        self.route('/workspace', 'GET', callback=self.get_workspace)
        self.route('/workspace', 'POST', callback=self.post_workspace)
        self.route('/pnlreset', 'POST', callback=self.reset_panel)

    def _http_error(self, status, msg):
        self.log_error(msg)
        return HTTPError(status=status, body=msg)

    def get_version(self):
        return {'version': version}

    def run_program(self):
        # retrieve the Python code passed as request body
        if self.runner and self.runner.active:
            return HTTPResponse(status=httplib.BAD_REQUEST, body='already running')

        py_code = request.body.read()

        if py_code == '':
            return self._http_error(httplib.BAD_REQUEST, 'empty program')

        if 'import ' in py_code:
            return self._http_error(httplib.BAD_REQUEST, 'unauthorized statement')

        self.panel.center_text_at('Sequence running...', 3)

        self.log_info('received code:')
        for line in py_code.split('\n'):
            self.log_info('>>> ' + line)
        self.log_info('-' * 40)

        self._terminate_event.clear()
        self.log_info('starting program execution')
        self.runner = Runner(
            py_code,
            arm=ArmProxy(self.arm, logger=self.logger, terminate_event=self._terminate_event),
            panel=self.panel,
            logger=self.logger
        )
        self.runner.start(on_terminated=self._runner_terminated)
        self._run_status = 'running'

    def _runner_terminated(self):
        self.runner = None
        self._run_status = 'terminated'

    def abort_execution(self):
        if not self.runner or not self.runner.active:
            return HTTPResponse(status=httplib.BAD_REQUEST, body='not running')

        self.log_info('aborting program execution')
        self._terminate_event.set()
        self.runner.join()
        self._run_status = 'aborted'

    def get_status(self):
        return {"status": self._run_status}

    def get_workspace(self):
        if os.path.exists(self._wksp_save_path):
            response.content_type = 'application/xml'
            with open(self._wksp_save_path) as fp:
                xml = fp.read()
                return xml

    def post_workspace(self):
        wksp_xml = request.body.read()
        if wksp_xml:
            with open(self._wksp_save_path, "w") as fp:
                fp.write(wksp_xml)

    def reset_panel(self):
        self.panel.clear()
        self.panel.center_text_at(self.app_title, 1)
        self.panel.center_text_at('Ready', 3)
        self.panel.leds_off()


class ArmProxy(object):
    PROXIED_METHODS = ('move', 'goto', 'open_gripper', 'close_gripper', 'go_home', 'move_gripper_at')

    def __init__(self, arm, logger, terminate_event):
        self.arm = arm
        self.logger = logger
        self._terminate_event = terminate_event

        for method_name in self.PROXIED_METHODS:
            setattr(self, method_name, self._wrap(getattr(self.arm, method_name)))

    def _wrap(self, method):
        def wrapper(*args, **kwargs):
            self.logger.info('.. executing %s', method.__name__)
            method(*args, **kwargs)
            if self._terminate_event.is_set():
                self.logger.info('termination signal received')
                raise Interrupted()
        return wrapper


class Runner(object):
    def __init__(self, pgm, arm, panel, logger):
        self.pgm = pgm
        self.arm = arm
        self.panel = panel
        self.logger = logger

        self._run_thread = None
        self._terminated_callback = None

    def start(self, on_terminated=None):
        if self._run_thread:
            raise RuntimeError('already running')

        def worker():
            self.logger.info('worker started')
            try:
                exec(self.pgm, {'arm': self.arm, 'panel': self.panel})
            except Interrupted:
                self.logger.info('worker interrupted')
            else:
                self.logger.info('worker terminated')
                if self._terminated_callback:
                    self._terminated_callback()

        self._terminated_callback = on_terminated
        self._run_thread = threading.Thread(target=worker)
        self._run_thread.start()

    @property
    def active(self):
        return self._run_thread and self._run_thread.is_alive()

    def join(self):
        if self._run_thread and self._run_thread.is_alive():
            self._run_thread.join(timeout=30)
            if self._terminated_callback:
                self._terminated_callback()


class Interrupted(Exception):
    pass
