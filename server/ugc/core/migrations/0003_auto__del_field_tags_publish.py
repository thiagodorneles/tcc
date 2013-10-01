# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Deleting field 'Tags.publish'
        db.delete_column(u'core_tags', 'publish_id')

        # Adding M2M table for field publish on 'Tags'
        db.create_table(u'core_tags_publish', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('tags', models.ForeignKey(orm[u'core.tags'], null=False)),
            ('publish', models.ForeignKey(orm[u'core.publish'], null=False))
        ))
        db.create_unique(u'core_tags_publish', ['tags_id', 'publish_id'])


    def backwards(self, orm):

        # User chose to not deal with backwards NULL issues for 'Tags.publish'
        raise RuntimeError("Cannot reverse this migration. 'Tags.publish' and its values cannot be restored.")
        # Removing M2M table for field publish on 'Tags'
        db.delete_table('core_tags_publish')


    models = {
        u'core.midia': {
            'Meta': {'object_name': 'Midia'},
            'content': ('django.db.models.fields.URLField', [], {'max_length': '200'}),
            'content_type': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'publish': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['core.Publish']"})
        },
        u'core.publish': {
            'Meta': {'ordering': "['-date_time']", 'object_name': 'Publish'},
            'date_time': ('django.db.models.fields.DateTimeField', [], {}),
            'description': ('django.db.models.fields.TextField', [], {}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'max_length': '50', 'blank': 'True'}),
            'status': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '100'})
        },
        u'core.tags': {
            'Meta': {'object_name': 'Tags'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'publish': ('django.db.models.fields.related.ManyToManyField', [], {'to': u"orm['core.Publish']", 'symmetrical': 'False'}),
            'tag': ('django.db.models.fields.CharField', [], {'max_length': '30'})
        }
    }

    complete_apps = ['core']