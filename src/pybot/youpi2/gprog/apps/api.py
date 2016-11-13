# -*- coding: utf-8 -*-

import httplib

from bottle import HTTPError, HTTPResponse, request, response
import bottle

from pybot.youpi2.http.base import YoupiBottleApp
from pybot.youpi2.http.__version__ import version

__author__ = 'Eric Pascual'


bottle.DEBUG = True


class RestAPIApp(YoupiBottleApp):
    """ REST API for controlling the arm.
    """
    def __init__(self, *args, **kwargs):
        super(RestAPIApp, self).__init__(*args, **kwargs)

        self.proxy = None

        self.route('/exec', 'POST', callback=self.execute)
        self.route('/abort', 'POST', callback=self.abort)

    def _http_error(self, status, msg):
        self.log_error(msg)
        return HTTPError(status, msg)

    def get_version(self):
        return {'version': version}

    def execute(self):
        # retrieve the Python code passed as request body
        py_code = request.body.read()

        if py_code == '':
            return self._http_error(httplib.BAD_REQUEST, 'empty program')

        if 'import ' in py_code:
            return self._http_error(httplib.BAD_REQUEST, 'unauthorized statement')

        try:
            self.log_info('starting sequence execution')
            self.proxy = ArmProxy(self.arm, logger=self.logger)
            exec(py_code, {'arm': self.proxy, 'panel': self.panel})
        except Interrupted:
            self.log_info('sequence aborted')
        except Exception as e:
            return self._http_error(httplib.INTERNAL_SERVER_ERROR, e.message)
        else:
            self.log_info('sequence complete')
        finally:
            self.proxy = None

    def abort(self):
        if self.proxy:
            self.log_info('starting sequence execution')
            self.proxy.abort()


class ArmProxy(object):
    PROXIED_METHODS = ('move', 'goto', 'open_gripper', 'close_gripper', 'go_home')

    def __init__(self, arm, logger):
        self.arm = arm
        self.logger = logger
        self._terminated = False

        for method_name in self.PROXIED_METHODS:
            setattr(self, method_name, self._wrap(getattr(self.arm, method_name)))

    def _wrap(self, method):
        def wrapper(*args, **kwargs):
            self.logger.info('.. executing %s', method.__name__)
            method(*args, **kwargs)
            if self._terminated:
                self.logger.info('termination signal received')
                raise Interrupted()
        return wrapper

    def abort(self):
        self._terminated = True


class Interrupted(Exception):
    pass
