{% set is_open_source = cookiecutter.open_source_license != 'Not open source' -%}
{% for _ in cookiecutter.project_name %}={% endfor %}
{{ cookiecutter.project_name }}
{% for _ in cookiecutter.project_name %}={% endfor %}

{% if is_open_source %}
.. image:: https://img.shields.io/pypi/v/{{ cookiecutter.project_slug }}.svg
        :target: https://pypi.python.org/pypi/{{ cookiecutter.project_slug }}

.. image:: https://img.shields.io/travis/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}.svg
        :target: https://travis-ci.com/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}

.. image:: https://readthedocs.org/projects/{{ cookiecutter.project_slug | replace("_", "-") }}/badge/?version=latest
        :target: https://{{ cookiecutter.project_slug | replace("_", "-") }}.readthedocs.io/en/latest/?version=latest
        :alt: Documentation Status
{%- endif %}

{% if cookiecutter.add_pyup_badge == 'y' %}
.. image:: https://pyup.io/repos/github/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/shield.svg
     :target: https://pyup.io/repos/github/{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}/
     :alt: Updates
{% endif %}


{{ cookiecutter.project_short_description }}

{% if is_open_source %}
* Free software: {{ cookiecutter.open_source_license }}
{% endif %}

Features
--------

* TODO

Requirements
------------

* TODO

Usage
-----

* TODO

Development
-----------

- Make utility

Set up the environment using the provided Makefile. Follow these steps:

1. Ensure you have `make` installed on your system. You can check this by running `make --version` in your terminal. Install or update `make` if needed.
2. Install the necessary dependencies by running `make install` or `make all`.
3. Create a Python virtual environment by running `python3 -m venv --prompt {{ cookiecutter.project_slug }} venv`. Activate it by running `source venv/bin/activate`.
4. Verify the installation by running `{{ cookiecutter.project_slug }} --version`. If the tool is installed correctly, it should display the version number.
5. Run the tool for example by running `python -m {{ cookiecutter.project_slug }} --help`.
6. Exit the virtual environment by running `deactivate`.


Credits
-------

This package was created with Cookiecutter_ and the `audreyr/cookiecutter-pypackage`_ project template.

.. _Cookiecutter: https://github.com/audreyr/cookiecutter
.. _`audreyr/cookiecutter-pypackage`: https://github.com/audreyr/cookiecutter-pypackage
