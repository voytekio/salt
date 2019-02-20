{% set data = salt['pillar.get']('data', None) %}
{% set hostname = data.get('id', None) %}

remove_from_config_file:
  file.blockreplace:
    - name: '/etc/icinga2/conf.d/hosts.conf'
    - content: ''
    - marker_start: "/* START-managed-host: {{ hostname }} */"
    - marker_end: "/* END-managed-host: {{ hostname }} */"
    - append_if_not_found: False
{#  - append_newline: True  2017/2018 ONLY #}
    - context:
        hostname: {{ hostname }}
    - show_changes: True

remove_line_start:
  file.line:
    - name: '/etc/icinga2/conf.d/hosts.conf'
    - content: "/* START-managed-host: {{ hostname }} */"
    - mode: delete
    - show_changes: True
    - onchanges:
      - file: remove_from_config_file

remove_line_end:
  file.line:
    - name: '/etc/icinga2/conf.d/hosts.conf'
    - content: "/* END-managed-host: {{ hostname }} */"
    - mode: delete
    - show_changes: True
    - onchanges:
      - file: remove_from_config_file

restart_icinga:
  module.run:
    - name: service.restart
    - m_name: icinga2
    - onchanges:
      - file: remove_from_config_file
