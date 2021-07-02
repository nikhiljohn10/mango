from django.db import models
from django.core.validators import validate_email
from django.contrib.auth.models import AbstractUser
from django.utils.translation import ugettext_lazy as _


class User(AbstractUser):
    email = models.EmailField(
        _('email address'),
        unique=True,
        help_text=_(
            'Email address is required.'
        ),
        validators=[validate_email],
        error_messages={
            'unique': _("A user with that email already exists."),
        },
    )
    email_verified = models.BooleanField(
        _('email verified'),
        default=False,
        help_text=_(
            'Designates whether the user\'s email address is verified.'
        ),
    )
    blocked = models.BooleanField(
        _('blocked'),
        default=False,
        help_text=_(
            'Designates whether this user is banned. '
        ),
    )
    location = models.CharField(blank=True, max_length=40)
    date_of_birth = models.DateField(blank=True, null=True)

    REQUIRED_FIELDS = []

    def __str__(self):
        if self.first_name and self.last_name:
            fullname = self.get_full_name()
            return fullname
        return self.username
