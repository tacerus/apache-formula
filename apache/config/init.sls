# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - .file
  - .vhosts
  {%- for site, site_config in salt['pillar.get']('apache:sites', {}).items() %}
  {%- if 'ProxyRoute' in site_config %}
  - .modules.mod_proxy
  {%- break %}
  {%- endif %}
  {%- endfor %}
  - .purge
