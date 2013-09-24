# coding: utf-8
from django.shortcuts import render
from django.http import HttpResponse

def homepage(request):
    return render(request, 'index.html')

def detail(request):
    return render(request, 'detail.html')    