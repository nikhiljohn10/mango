from rest_framework import routers
from api.views import SnippetViewSet

router = routers.DefaultRouter()
router.register(r'snippets', SnippetViewSet)

urlpatterns = router.urls
