{% set ip = salt.pillar.get('target_ip', 'blank_ip') %}
{% set interface_name = salt.pillar.get('interface_name', 'blank_int') %}

test_change:
    test.configurable_test_state:
      - changes: True
show_notify:
    test.show_notification:
      - text: ip is {{ ip }}

{% if grains['osmajorrelease'] == 18 and 'Ubuntu' in grains['os'] %}
manage_ip_interfaces_file:
    file.managed:
      - name: /etc/netplan/01-netcfg.yaml
      - source: salt://files/templates/netcfg.yaml
      - template: jinja
      - context:
        ip: {{ ip }}
        interface_name: {{ interface_name }}
      - mode: 644
{% else %}
    file.managed:
      - name: /etc/network/interfaces
      - source: salt://files/templates/ip_interfaces
      - template: jinja
      - context:
        ip: {{ ip }}
      - mode: 644
{% endif %}


schedule_restart:
    cmd.run:
      - name: 'at now + 1 minute -f /installers/at-reboot.sh'
      - onchanges_any:
{% if grains['osmajorrelease'] == 18 and 'Ubuntu' in grains['os'] %}
        - file: /etc/netplan/01-netcfg.yaml
{% else %}
        - file: /etc/network/interfaces
{% endif %}

