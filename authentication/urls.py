from rest_framework import routers
from django.urls import path, include
from authentication.views import UserViewSet, GroupViewSet

router = routers.DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'groups', GroupViewSet)

urlpatterns = [
    path('', include('rest_framework.urls', namespace='authentication')),
]
