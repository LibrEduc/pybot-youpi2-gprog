from setuptools import setup, find_packages

setup(
    name='pybot-youpi2-gprog',
    setup_requires=['setuptools_scm'],
    use_scm_version={
        'write_to': 'src/pybot/youpi2/gprog/__version__.py'
    },
    namespace_packages=['pybot', 'pybot.youpi2'],
    packages=find_packages("src"),
    package_dir={'': 'src'},
    package_data={'pybot.youpi2.gprog': [
        # Javascript
        'data/static/js/*.min.js',
        'data/static/js/*_compressed.js',
        'data/static/js/python_compressed.js',
        'data/static/js/fr.js',
        'data/static/js/blocks_youpi.js',
        # data
        'data/static/xml/toolbox.xml',
        # graphics
        'data/static/img/*',
        # templates
        'data/templates/*.tpl'
    ]},
    url='',
    license='',
    author='Eric Pascual',
    author_email='eric@pobot.org',
    install_requires=['pybot-youpi2-http'],
    download_url='https://github.com/Pobot/PyBot',
    description='Youpi2 graphical programming demonstration',
    entry_points={
        'console_scripts': [
            'youpi2-gprog-server = pybot.youpi2.gprog.server:main',
        ]
    }
)
