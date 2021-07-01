PYTHON     := $(shell which python)
PYTHON_PIP := $(shell which pip)

check_env:
ifeq ($(VIRTUAL_ENV), )
	@echo "Error: Virtual environment is required."
	@echo "Try '. venv/bin/activate' or 'source venv/bin/activate'"
	@exit 1
endif

setup:
	@cp .env.example .env
	@$(PYTHON_PIP) install -r requirement.txt

app:
	@printf "Enter app name: " && read NAME; $(PYTHON) manage.py startapp $$NAME

migrate: check_env
	@$(PYTHON) manage.py makemigrations
	@$(PYTHON) manage.py migrate

super: check_env
	@echo "Creating 'admin' superuser"
	@$(PYTHON) manage.py createsuperuser --username admin

clean:
	@find . -path ./venv -prune -o \
		\( -name __pycache__ -o -name db.sqlite3 -o -name .env \) \
		-exec rm -rf {} +
	@rm -r \
		./authentication/migrations/* \
		./api/migrations/*
	@touch \
		./authentication/migrations/__init__.py \
		./api/migrations/__init__.py

run: check_env
	@if ! test -f ".env"; then \
		echo "Error: Need to setup project before running." && exit 1; \
	fi
	@$(PYTHON) manage.py runserver 0.0.0.0:8000

test:
	@$(PYTHON) manage.py test

init: setup migrate super run

dev: migrate run

.PHONY: clean migrate setup init run
