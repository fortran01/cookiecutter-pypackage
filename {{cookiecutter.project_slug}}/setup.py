# https://github.com/httpie/cli/blob/master/setup.py

from setuptools import setup, find_packages

PROJECT_NAME = '{{cookiecutter.project_slug}}'
this_project = __import__(PROJECT_NAME)

# Note: keep requirements here to ease distributions packaging
tests_require = ["pytest"]
dev_require = [
    "pip",
    "bump2version",
    "wheel",
    "watchdog",
    "flake8",
    "coverage",
    "Sphinx",
    "twine",
{%- filter indent(width=4) %}
{% if cookiecutter.command_line_interface|lower == 'click' -%}
    'click',{% endif %}
{% if cookiecutter.use_pytest == 'y' -%}
    'pytest',{% endif -%}
{% if cookiecutter.use_black == 'y' -%}
    'black',{% endif -%}       
{%- endfilter %}
]
install_requires = [
    'pip',
    {%- if cookiecutter.command_line_interface|lower == 'click' %}
    'click',
    {%- endif %}
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


def long_description():
    with open('README.md', encoding='utf-8') as f:
        return f.read()


{%- set license_classifiers = {
    'MIT license': 'License :: OSI Approved :: MIT License',
    'BSD license': 'License :: OSI Approved :: BSD License',
    'ISC license': 'License :: OSI Approved :: ISC License (ISCL)',
    'Apache Software License 2.0': 'License :: OSI Approved :: Apache Software License',
    'GNU General Public License v3': 'License :: OSI Approved :: GNU General Public License v3 (GPLv3)'
} %}


setup(
    name=PROJECT_NAME,
    version=this_project.__version__,
    description="{{ cookiecutter.project_short_description }}",
    long_description=long_description(),
    long_description_content_type="text/markdown",
    url='https://github.com/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}',
    author="{{ cookiecutter.full_name.replace('\"', '\\\"') }}",
    author_email='{{ cookiecutter.email }}',
{%- if cookiecutter.open_source_license in license_classifiers %}
    license="{{ cookiecutter.open_source_license }}",
{%- endif %}
    packages=find_packages(include=[f"{PROJECT_NAME}", f"{PROJECT_NAME}.*"]),
    {%- if 'no' not in cookiecutter.command_line_interface|lower %}
    entry_points={
        'console_scripts': [
            '{{ cookiecutter.project_slug }}={{ cookiecutter.project_slug }}.cli:main',
        ],
    },
    {%- endif %}
    python_requires=">=3.10",
    extras_require=extras_require,
    install_requires=install_requires,
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
{%- if cookiecutter.open_source_license in license_classifiers %}
        '{{ license_classifiers[cookiecutter.open_source_license] }}',
{%- endif %}
        'Natural Language :: English',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
    ]
)
