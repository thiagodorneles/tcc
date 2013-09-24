# coding: utf-8
from django.test import TestCase

class HomepageTest(TestCase):
    def setUp(self):
        self.resp = self.client.get('/')

    def test_get(self):
        'GET / must return status code 200.'
        self.assertEqual(200, self.resp.status_code)

    def test_template(self):
        'Homepage must use template index.html'
        self.assertTemplateUsed(self.resp, 'index.html')

    def test_html(self):
        'Html must contain input controls'
        self.assertContains(self.resp, '<form')
        self.assertContains(self.resp, '<input', 1)
        self.assertContains(self.resp, '<button', 1)
        self.assertContains(self.resp, 'type="text"', 1)
        self.assertContains(self.resp, 'type="submit"', 1)

class DetailTest(TestCase):
    def setUp(self):
        self.resp = self.client.get('/publicacao/')

    def test_get(self):
        'GET /publicacao/1/ shoud return status code 200.'
        self.assertEqual(200, self.resp.status_code)

    def test_template(self):
        'Response shoud be a rendered template'
        self.assertTemplateUsed(self.resp, 'detail.html')