# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'Midia'
        db.create_table(u'core_midia', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('content', self.gf('django.db.models.fields.URLField')(max_length=200)),
            ('content_type', self.gf('django.db.models.fields.CharField')(max_length=100)),
            ('publish', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['core.Publish'])),
        ))
        db.send_create_signal(u'core', ['Midia'])

        # Adding model 'Publish'
        db.create_table(u'core_publish', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('title', self.gf('django.db.models.fields.CharField')(max_length=100)),
            ('description', self.gf('django.db.models.fields.TextField')()),
            ('date_time', self.gf('django.db.models.fields.DateTimeField')()),
            ('location', self.gf('django.db.models.fields.CharField')(max_length=50, blank=True)),
            ('status', self.gf('django.db.models.fields.BooleanField')(default=False)),
        ))
        db.send_create_signal(u'core', ['Publish'])

        # Adding model 'Tags'
        db.create_table(u'core_tags', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('tag', self.gf('django.db.models.fields.CharField')(max_length=30)),
            ('publish', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['core.Publish'])),
        ))
        db.send_create_signal(u'core', ['Tags'])


    def backwards(self, orm):
        # Deleting model 'Midia'
        db.delete_table(u'core_midia')

        # Deleting model 'Publish'
        db.delete_table(u'core_publish')

        # Deleting model 'Tags'
        db.delete_table(u'core_tags')


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
            'publish': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['core.Publish']"}),
            'tag': ('django.db.models.fields.CharField', [], {'max_length': '30'})
        }
    }

    complete_apps = ['core']