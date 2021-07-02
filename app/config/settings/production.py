from .common import *

import environ

env = environ.Env(DEBUG=(bool, False))
environ.Env.read_env()

DEBUG = env('DEBUG')
SECRET_KEY = env('SECRET_KEY')
REST_FRAMEWORK['PAGE_SIZE'] = env.int('DJANGO_PAGINATION_LIMIT', default=10)

if env.bool('DJANGO_PRODUCTION_POSTGRES'):
    DATABASES = {
        'default': db.config(
            conn_max_age=env.int('POSTGRES_CONN_MAX_AGE', 500)
        )
    }

CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_SSL_REDIRECT = True
SECURE_HSTS_SECONDS = 86400
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
