{% set ip = salt.pillar.get('target_ip', 'blank_ip') %}

test_change:
    test.configurable_test_state:
      - changes: True

show_notify:
    test.show_notification:
      - text: ip is {{ ip }}

schedule_restart:
    cmd.run:
      - name: 'at now + 1 minute -f /installers/at-reboot.sh'
      - onchanges:
        - file: /etc/network/interfaces

manage_ip_interfaces_file:
    file.managed:
      - name: /etc/network/interfaces
      - source: salt://files/templates/ip_interfaces
      - template: jinja
      - context:
        ip: {{ ip }}
      - mode: 644

