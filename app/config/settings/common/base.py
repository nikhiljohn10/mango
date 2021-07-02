from .default import *

ALLOWED_HOSTS = ['*']

LANGUAGE_CODE = 'en-in'
TIME_ZONE = 'Asia/Kolkata'
USE_I18N = False

EMAIL_HOST = 'localhost'
EMAIL_PORT = 1025
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

INSTALLED_APPS += [
    'rest_framework',
    'rest_framework.authtoken',
    'django_filters',
    'authentication',
    'api',
]

ADMINS = (
        ('Nikhil John', 'me@nikz.in'),
    )

STATIC_ROOT = BASE_DIR / 'static'
STATIC_URL = '/static/'
STATICFILES_DIRS = []
STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
)

MEDIA_ROOT = BASE_DIR / 'media'
MEDIA_URL = '/media/'
