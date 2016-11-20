# -*- coding: utf-8 -*-

from pybot.youpi2.http.base import YoupiBottleApp

from ..__version__ import version

__author__ = 'Eric Pascual'


class UIApp(YoupiBottleApp):
    def __init__(self, *args, **kwargs):
        super(UIApp, self).__init__(*args, **kwargs)

        self.route('/', callback=self.gprog)
        self.route('/gprog', callback=self.gprog)
        self.route('/help', callback=self.help)
        self.route('/about', callback=self.about)

    def get_context(self, **kwargs):
        context = {
            'title': 'Youpi 2.0',
            'version': version
        }
        context.update(kwargs)
        return context

    def gprog(self):
        return self.render_template('gprog')

    def help(self):
        return self.render_template('help')

    def about(self):
        return self.render_template('about')
