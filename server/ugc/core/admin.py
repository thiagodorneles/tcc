# coding: utf-8
from django.contrib import admin
from ugc.core.models import Publish
from ugc.core.models import Tags
from ugc.core.models import Midia

class PublishAdmin(admin.ModelAdmin):
    list_display = ('title', 'date_time', 'status')

admin.site.register(Publish, PublishAdmin)
admin.site.register(Tags)
admin.site.register(Midia)