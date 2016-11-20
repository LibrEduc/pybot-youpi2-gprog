# -*- coding: utf-8 -*-

from pybot.youpi2.http.base import HTTPServerApp

from .__version__ import version
from .apps.api import RestAPIApp
from .apps.ui import UIApp

__author__ = 'Eric Pascual'

my_package = '.'.join(__name__.split('.')[:-1])


class GProgServerApp(HTTPServerApp):
    NAME = 'gprog'
    TITLE = "Graphic Programming"
    VERSION = version

    RESOURCES_SEARCH_PATH = ['pybot.youpi2.http', my_package]
    DISPLAY_REQUESTS_ON_LCD = False

    def get_apps(self):
        ui_app = UIApp(arm=self.arm, panel=self.pnl, name='app-ui', log_level=self.log_getEffectiveLevel())
        api_app = RestAPIApp(arm=self.arm, panel=self.pnl, name='app-api', log_level=self.log_getEffectiveLevel())
        api_app.app_title = self.TITLE

        return ui_app, api_app


def main():
    GProgServerApp.main()
