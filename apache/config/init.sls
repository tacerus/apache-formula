# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set extra_includes = [] %}
{%- for site, site_config in salt['pillar.get']('apache:sites', {}).items() %}

{%- if 'ProxyRoute' in site_config %}
{%- if 'modules.mod_proxy' not in extra_includes %}
{%- do extra_includes.append('modules.mod_proxy') %}
{%- endif %}
{%- endif %}

{%- if 'SSLCertificateFile' in site_config %}
{%- if 'modules.mod_ssl' not in extra_includes %}
{%- do extra_includes.append('modules.mod_ssl') %}
{%- endif %}
{%- endif %}

{%- endfor %}

include:
  {%- for extra_include in extra_includes %}
  - .{{ extra_include }}
  {%- endfor %}
  - .file
  - .vhosts
  - .purge
