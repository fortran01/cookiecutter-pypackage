# !/usr/bin/env python

# Note: keep requirements here to ease distributions packaging
tests_require = ["pytest"]

dev_require = [
    "pip",
    "wheel",
    "pytest",
    "tox",
    "cookiecutter>=1.4.0",
    "pytest-cookies",
    "alabaster==0.7.12",
    "watchdog==0.9.0",
]

install_requires = [
    'pip',
]

install_requires_win_only = [
    "colorama>=0.2.4",
]

# bdist_wheel
extras_require = {
    "dev": dev_require,
    "test": tests_require,
    # https://wheel.readthedocs.io/en/latest/#defining-conditional-dependencies
    ':sys_platform == "win32"': install_requires_win_only,
}

from distutils.core import setup
setup(
    name='cookiecutter-pypackage',
    packages=[],
    version='0.1.0',
    description='Cookiecutter template for a Python package',
    author='Audrey Roy Greenfeld',
    license='BSD',
    author_email='aroy@alum.mit.edu',
    url='https://github.com/audreyr/cookiecutter-pypackage',
    keywords=['cookiecutter', 'template', 'package', ],
    python_requires='>=3.6',
    extras_require=extras_require,
    classifiers=[
        'Development Status :: 4 - Beta',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Natural Language :: English',
        'License :: OSI Approved :: BSD License',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: Implementation :: CPython',
        'Programming Language :: Python :: Implementation :: PyPy',
        'Topic :: Software Development',
    ],
)
