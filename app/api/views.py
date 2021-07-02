from api.models import Snippet
from api.permissions import IsOwnerOrReadOnly
from rest_framework import serializers, permissions, viewsets, renderers
from rest_framework.response import Response
from rest_framework.decorators import action


class SnippetSerializer(serializers.HyperlinkedModelSerializer):
    owner = serializers.HyperlinkedIdentityField(view_name='user-detail')
    highlight = serializers.HyperlinkedIdentityField(
        view_name='snippet-highlight',
        format='html'
    )

    class Meta:
        model = Snippet
        fields = [
            'url',
            'id',
            'highlight',
            'owner',
            'title',
            'code',
            'linenos',
            'language',
            'style',
        ]


class SnippetViewSet(viewsets.ModelViewSet):
    queryset = Snippet.objects.all()
    serializer_class = SnippetSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly,
                          IsOwnerOrReadOnly]

    @action(detail=True, renderer_classes=[renderers.StaticHTMLRenderer])
    def highlight(self, request, *args, **kwargs):
        snippet = self.get_object()
        return Response(snippet.highlighted)

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)
