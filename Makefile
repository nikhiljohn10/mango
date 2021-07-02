PYTHON     := $(shell which python)
PYTHON_PIP := $(shell which pip)

help:
	@echo "make venv"
	@echo ". venv/bin/activate  = Activate virtual environment"
	@echo "make init            = Initiate project"
	@echo "make app             = Create new app"
	@echo "make reset           = Reset project"
	@echo "make test            = Test project"
	@echo "deactivate"
	@echo "make clean-all"

check_env:
ifeq ($(VIRTUAL_ENV), )
	@echo "Error: Virtual environment is required."
	@echo "Try '. venv/bin/activate' or 'source venv/bin/activate'"
	@exit 1
endif

reset:
	@find ./app -path ./venv -prune -o \
		\( -name __pycache__ -o -name db.sqlite3 -o -name .env \) \
		-exec rm -rf {} +
	@rm -r \
		./app/authentication/migrations/* \
		./app/api/migrations/*
	@touch \
		./app/authentication/migrations/__init__.py \
		./app/api/migrations/__init__.py

clean-all:
ifeq ($(VIRTUAL_ENV), )
	@rm -rf ./venv
	@find ./app \( -name db.sqlite3 -o -name .env -o -name __pycache__ \) \
		-exec rm -rf {} +
endif

venv: clean-all
ifeq ($(VIRTUAL_ENV), )
	@python3 -m pip install --upgrade pip
	@python3 -m venv venv \
	&& echo "Use . venv/bin/activate" \
	|| (python3 -m pip install --user virtualenv && python3 -m venv venv)
endif

setup:
	@cp .env.example .env
	@$(PYTHON_PIP) install -r requirement.txt

app:
	@printf "Enter app name: " && read NAME; $(PYTHON) manage.py startapp $$NAME

migrate: check_env
	@$(PYTHON) app/manage.py makemigrations
	@$(PYTHON) app/manage.py migrate

super: check_env
	@echo "Creating 'admin' superuser"
	@$(PYTHON) app/manage.py createsuperuser --username admin

run: check_env
	@if ! test -f ".env"; then \
		echo "Error: Need to setup project before running." && exit 1; \
	fi
	@$(PYTHON) app/manage.py runserver 0.0.0.0:8000

test:
	@$(PYTHON) app/manage.py test

init: setup migrate super run

dev: migrate run

.PHONY: reset migrate setup init run
