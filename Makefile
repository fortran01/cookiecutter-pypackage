# https://github.com/httpie/cli/blob/master/Makefile

.PHONY: build

BAKE_OPTIONS=--no-input
PROJECT_NAME=cookiecutter-pypackage
H1="\n\n\033[0;32m\#\#\# "
H1END=" \#\#\# \033[0m\n"

# Only used to create our venv.
SYSTEM_PYTHON=python3

VENV_ROOT=venv
VENV_BIN=$(VENV_ROOT)/bin
VENV_PIP=$(VENV_BIN)/pip3
VENV_PYTHON=$(VENV_BIN)/python

export PATH := $(VENV_BIN):$(PATH)

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

default: list-tasks

###############################################################################
# Default task to get a list of tasks when `make' is run without args.
# <https://stackoverflow.com/questions/4219255>
###############################################################################

list-tasks:
	@echo Available tasks:
	@echo ----------------
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo

###############################################################################
# Installation
###############################################################################

all: uninstall-$(PROJECT_NAME) install test

install: venv install-reqs

install-reqs:
	@echo $(H1)Updating package tools$(H1END)
	$(VENV_PIP) install --upgrade pip wheel build

	@echo $(H1)Installing dev requirements$(H1END)
	$(VENV_PIP) install --upgrade '.[dev]' '.[test]'

	@echo $(H1)Installing $(PROJECT_NAME)$(H1END)
	$(VENV_PIP) install --upgrade --editable .

	@echo

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean:
	@echo $(H1)Cleaning up$(H1END)
	rm -rf $(VENV_ROOT)
	# Remove symlink for virtualenvwrapper, if we’ve created one.
	[ -n "$(WORKON_HOME)" -a -L "$(WORKON_HOME)/$(PROJECT_NAME)" -a -f "$(WORKON_HOME)/$(PROJECT_NAME)" ] && rm $(WORKON_HOME)/$(PROJECT_NAME) || true
	rm -rf *.egg dist build .coverage .cache .pytest_cache $(PROJECT_NAME).egg-info
	find . -name '__pycache__' -delete -o -name '*.pyc' -delete
	@echo
	
venv:
	@echo $(H1)Creating a Python environment $(VENV_ROOT) $(H1END)

	$(SYSTEM_PYTHON) -m venv --prompt $(PROJECT_NAME) $(VENV_ROOT)

	@echo
	@echo done.
	@echo
	@echo To activate it manually, run:
	@echo
	@echo "    source $(VENV_BIN)/activate"
	@echo
	@echo '(learn more: https://docs.python.org/3/library/venv.html)'
	@echo
	@if [ -n "$(WORKON_HOME)" ]; then \
		echo $(ROOT_DIR) >  $(VENV_ROOT)/.project; \
		if [ ! -d $(WORKON_HOME)/$(PROJECT_NAME) -a ! -L $(WORKON_HOME)/$(PROJECT_NAME) ]; then \
			ln -s $(ROOT_DIR)/$(VENV_ROOT) $(WORKON_HOME)/$(PROJECT_NAME) ; \
			echo ''; \
			echo 'Since you use virtualenvwrapper, we created a symlink'; \
			echo 'so you can also use "workon $(PROJECT_NAME)" to activate the venv.'; \
			echo ''; \
		fi; \
	fi

###############################################################################
# Uninstalling
###############################################################################

uninstall-$(PROJECT_NAME):
	@echo $(H1)Uninstalling $(PROJECT_NAME)$(H1END)
	- $(VENV_PIP) uninstall --yes $(PROJECT_NAME) &2>/dev/null

	@echo "Verifying…"
	cd .. && ! $(VENV_PYTHON) -m $(PROJECT_NAME) --version &2>/dev/null

	@echo "Done"
	@echo

###############################################################################
# Testing
###############################################################################

test:
	@echo $(H1)Running tests$(HEADER_EXTRA)$(H1END)
	$(VENV_BIN)/python -m pytest $(COV)
	@echo

test-cover: COV=--cov=$(PROJECT_NAME) --cov=tests
test-cover: HEADER_EXTRA=' (with coverage)'
test-cover: test

test-all: clean install test test-dist codestyle ## test-all is meant to test everything — even this Makefile
	@echo

test-dist: test-sdist test-bdist-wheel
	@echo


test-sdist: clean venv
	@echo $(H1)Testing sdist build an installation$(H1END)
	$(VENV_PYTHON) setup.py sdist
	$(VENV_PIP) install --force-reinstall --upgrade dist/*.gz
	$(VENV_BIN)/{PROJECT_NAME} --version
	@echo

test-bdist-wheel: clean venv
	@echo $(H1)Testing wheel build an installation$(H1END)
	$(VENV_PIP) install wheel
	$(VENV_PYTHON) setup.py bdist_wheel
	$(VENV_PIP) install --force-reinstall --upgrade dist/*.whl
	$(VENV_BIN)/{PROJECT_NAME} --version
	@echo


twine-check:
	twine check dist/*

# Kept for convenience, "make codestyle" is preferred though
pycodestyle: codestyle


codestyle:
	@echo $(H1)Running flake8$(H1END)
	@[ -f $(VENV_BIN)/flake8 ] || $(VENV_PIP) install --upgrade --editable '.[dev]'
	$(VENV_BIN)/flake8 $(PROJECT_NAME)/ tests/ *.py
	@echo

codecov-upload:
	@echo $(H1)Running codecov$(H1END)
	@[ -f $(VENV_BIN)/codecov ] || $(VENV_PIP) install codecov
	# $(VENV_BIN)/codecov --required
	$(VENV_BIN)/codecov
	@echo

doc-check:
	@echo $(H1)Running documentations checks$(H1END)
	@echo Placeholder for documentation checks

lint/flake8: ## check style with flake8
	flake8 natifylambda tests

lint: lint/flake8 ## check style

###############################################################################
# Cookiecutter
###############################################################################
help:
	@echo "bake 	generate project using defaults"
	@echo "watch 	generate project using defaults and watch for changes"
	@echo "replay 	replay last cookiecutter run and watch for changes"

bake:
	cookiecutter $(BAKE_OPTIONS) . --overwrite-if-exists

watch: bake
	watchmedo shell-command -p '*.*' -c 'make bake -e BAKE_OPTIONS=$(BAKE_OPTIONS)' -W -R -D \{{cookiecutter.project_slug}}/

replay: BAKE_OPTIONS=--replay
replay: watch
	;
