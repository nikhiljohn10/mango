PYTHON     := $(shell which python)
PYTHON_PIP := $(shell which pip)
APP_ROOT   := $(shell pwd)/app
API_ROOT   := $(shell pwd)/api

help:
	@echo
	@echo "COMMANDS:"
	@echo
	@echo " make venv              : Generate virtual environment"
	@echo " . venv/bin/activate    : Activate virtual environment"
	@echo " make init              : Initiate project"
	@echo " make app               : Create new app"
	@echo " make reset             : Reset project"
	@echo " make test              : Test project"
	@echo " deactivate             : Deactivate virital environment"
	@echo " make clean-all         : Remove all temporary files"
	@echo

check_env:
ifeq ($(VIRTUAL_ENV), )
	@echo "Error: Virtual environment is required."
	@echo "Try '. venv/bin/activate' or 'source venv/bin/activate'"
	@exit 1
endif

reset:
	@find $(API_ROOT) -name __pycache__ -exec rm -rf {} +
	@find $(APP_ROOT) \( -name __pycache__ -o -name db.sqlite3 -o -name .env \) \
		-exec rm -rf {} +
	@rm -r \
		$(APP_ROOT)/authentication/migrations/* \
		$(APP_ROOT)/api/migrations/*
	@touch \
		$(APP_ROOT)/authentication/migrations/__init__.py \
		$(APP_ROOT)/api/migrations/__init__.py

clean-all:
ifeq ($(VIRTUAL_ENV), )
	@rm -rf ./venv
	@find $(APP_ROOT) \( -name db.sqlite3 -o -name .env -o -name __pycache__ \) \
		-exec rm -rf {} +
endif

venv: clean-all
ifeq ($(VIRTUAL_ENV), )
	@(python3 -m venv venv || virtualenv venv 1> /dev/null) \
		&& echo "Use '. venv/bin/activate' to start development."
	@./venv/bin/python -m pip install --upgrade pip 2> /dev/null \
		|| echo "Error: Pip module is missing."
endif

setup:
	@cp $(APP_ROOT)/.env.example $(APP_ROOT)/.env
	@$(PYTHON_PIP) install -r requirement.txt

app:
	@printf "Enter app name: " && read NAME; $(PYTHON) manage.py startapp $$NAME

migration: check_env
	@$(PYTHON) $(APP_ROOT)/manage.py makemigrations
	@$(PYTHON) $(APP_ROOT)/manage.py migrate

super: check_env
	@echo "Creating 'admin' superuser"
	@$(PYTHON) $(APP_ROOT)/manage.py createsuperuser --username admin

run: check_env
	@if ! test -f "$(APP_ROOT)/.env"; then \
		echo "Error: Need to setup project before running." && exit 1; \
	fi
	@$(PYTHON) $(APP_ROOT)/manage.py runserver 0.0.0.0:8000

test:
	@$(PYTHON) $(APP_ROOT)/manage.py test

init: setup migration super run

dev: migration run

.PHONY: reset migrate setup init run
