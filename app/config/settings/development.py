from .common import *

SECURE_SSL_REDIRECT = False
REST_FRAMEWORK['DEFAULT_RENDERER_CLASSES'] += ('rest_framework.renderers.BrowsableAPIRenderer',)
