from django.contrib.auth.models import Group
from rest_framework import serializers, viewsets
from django.contrib.auth import get_user_model

User = get_user_model()


class UserSerializer(serializers.HyperlinkedModelSerializer):
    snippets = serializers.HyperlinkedRelatedField(
        many=True,
        view_name='snippet-detail',
        read_only=True,
    )

    class Meta:
        model = User
        ordering = ['-id']
        fields = [
            'url',
            'id',
            'username',
            'first_name',
            'last_name',
            'email',
            'email_verified',
            'snippets',
            'location',
            'date_of_birth',
            'blocked',
            'is_active',
            'is_staff',
            'date_joined',
        ]


class GroupSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Group
        fields = ['url', 'name']


class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer


class GroupViewSet(viewsets.ModelViewSet):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer
