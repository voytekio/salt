{% set data = salt['pillar.get']('data', None) %}
{% set hostname = data.get('id', None) %}
add_to_config_file:
  file.blockreplace:
    - name: '/etc/icinga2/conf.d/hosts.conf'
    - source: salt://files/templates/icinga_host_object
    - marker_start: "/* START-managed-host: {{ hostname }} */"
    - marker_end: "/* END-managed-host: {{ hostname }} */\n"
    - append_if_not_found: True
{#  - append_newline: True  2017/2018 ONLY #}
    - template: jinja
    - context:
        hostname: {{ hostname }}
    - show_changes: True

restart_icinga:
  module.run:
    - name: service.restart
    - m_name: icinga2
    - onchanges:
      - file: add_to_config_file
