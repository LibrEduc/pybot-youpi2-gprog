# -*- coding: utf-8 -*-

from pybot.youpi2.http.base import YoupiBottleApp
from pybot.youpi2.http.__version__ import version

__author__ = 'Eric Pascual'


class UIApp(YoupiBottleApp):
    def __init__(self, *args, **kwargs):
        super(UIApp, self).__init__(*args, **kwargs)

        self.route('/', callback=self.ui_gprog)
        self.route('/gprog', callback=self.ui_gprog)
        self.route('/help', callback=self.ui_help)

    def get_context(self, **kwargs):
        context = {
            'title': 'Youpi 2.0',
            'version': version
        }
        context.update(kwargs)
        return context

    def ui_gprog(self):
        return self.render_template('ui_gprog')

    def ui_help(self):
        return self.render_template('ui_help')