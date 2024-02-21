{%- from 'apache/map.jinja' import apache %}

{%- if apache.get('purge', False) %}
{%- set sites = apache.get('sites', {}).keys() | list + ['vhost-ssl.template', 'vhost.template'] %} {#- avoid tampering with packaged files -#}

{%- for file in salt['file.find'](apache.vhostdir, print='name', type='f') %}
{%- if file.replace('.conf', '') not in sites %}
apache-config-vhosts-purge-{{ file }}:
  file.absent:
    - name: {{ apache.vhostdir }}/{{ file }}
{%- endif %}
{%- endfor %}

{%- if grains.os_family == 'Suse' %} {#- purge conf.d files not managed by packages -#}
{%- for file in salt['file.find']('/etc/apache2/conf.d', type='f') %}
{%- if salt['cmd.retcode']('rpm -fq --quiet ' ~ file) == 1 %}
apache-config-conf-purge-{{ file }}:
  file.absent:
    - name: {{ file }}
{%- endif %}
{%- endfor %}
{%- endif %} {#- close SUSE check #}

{%- endif %} {#- close purge check #}
