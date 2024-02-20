# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import apache with context %}

{#- consider moving this to an optional state or enabling it with a pillar option
    {%- if 'deps' in apache.pkg and apache.pkg.deps and apache.pkg.deps is iterable and apache.pkg.deps is not string %}
apache-package-install-deps-pkg-installed:
  pkg.installed:
    - names: {{ apache.pkg.deps|json }}
    - require:
      - apache-package-install-pkg-installed
    {%- endif %}
#}

apache-package-install-pkg-installed:
    {%- if grains.os_family == 'Windows' %}
  service.dead:
    - name: {{ apache.service.name }}  # port 8080
  chocolatey.installed:
    - name: {{ apache.pkg.name }}
    - force: True

    {%- else %}

  pkg.installed:
    - name: {{ apache.pkg.name }}

    {%- if grains.os_family != 'Suse' %}
  group.present:
    - name: {{ apache.group }}
    - system: True
  user.present:
    - name: {{ apache.user }}
    - gid: {{ apache.group }}
    - system: True
    {%- endif %}

    {%- endif %}
