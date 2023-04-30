# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import apache with context %}

apache-service-running:
  service.running:
    - name: {{ apache.service.name }}
    - enable: True
    - reload: True
