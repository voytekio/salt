{% set target_fqdn = salt.pillar.get('target_fqdn', 'blank_target_fqdn') %}
{% set target_ip = salt.pillar.get('target_ip', 'blank_target_ip') %}
{% set dns_host = salt.pillar.get('dns_host', 'blank_dns_host') %}
{% set zone_file = '/etc/bind/zones/db.v2.com' %}
{% set zone_tempfile = '/etc/bind/zones/db.v2.com-temp' %}
{% set target_hostname = target_fqdn.split('.')[0] %}
{% set skip_dns = salt.pillar.get('skip_dns', False)%}
{% set skip_set_ip_part = salt.pillar.get('skip_set_ip_part', False)%}
{% set test_ping = salt['saltutil.cmd'](target_fqdn, 'test.ping') %}

{% if test_ping %}
  {% set target_minion_name = target_fqdn %}
{% else %}
  {% set target_minion_name = target_hostname %}
{% endif %}

log_msg1:
  module.run:
    - log.error:
      - message: "target_minion_name is: {{ target_minion_name }}"

{% if not skip_dns %}
start_somewhere:
  salt.function:
    - name: test.retcode
    - tgt: {{ dns_host}}
    - kwarg:
        code: 0

append_temp_zone_file:
  salt.state:
    - sls: states.append_dns_zone
    - tgt: {{ dns_host}}
    #- test: True
    - pillar:
        target_fqdn: {{ target_fqdn }}
        target_ip: {{ target_ip }}
        source_file_location: {{ zone_file }}
        destination_file_location: {{ zone_tempfile }}

test_new_zonefile:
  salt.function:
    - name: cmd.run
    - tgt: {{ dns_host}}
    - kwarg:
        cmd: 'named-checkzone v2.com {{ zone_tempfile }}'
    - onchanges:
        - salt: append_temp_zone_file

update_real_zone_file:
  salt.state:
    - sls: states.append_dns_zone
    - tgt: {{ dns_host}}
    - pillar:
        source_file_location: {{ zone_tempfile }}
        destination_file_location: {{ zone_file }}
    - onchanges:
        - salt: test_new_zonefile

restart_bind:
  salt.function:
    - tgt: {{ dns_host}}
    - name: service.restart
    - arg:
        - bind9
    - onchanges:
        - salt: update_real_zone_file

log_some_output:
    salt.function:
      - name: test.outputter
      - tgt: {{ dns_host}}
      - kwarg:
          data: {{ target_minion_name }}
{% endif %}

{% if not skip_set_ip_part %}

  {# find interface name. skip the localhost one. If multiple ints found, we'll pick the first one #}
  {% set interface_grain = salt['saltutil.cmd'](target_minion_name, 'grains.get', ['ip_interfaces']) %}
  {% set interfaces = interface_grain.get(target_minion_name).get("ret") %}
  {% set interface_name = [] %}
  {% for key, value in interfaces.items() %}
    {% if key not in 'lo' %}
      {# see https://stackoverflow.com/questions/46939756/setting-variable-in-jinja-for-loop-doesnt-persist-between-iterations #}
      {% if interface_name.append(key) %}{% endif %}
    {% endif %}
  {% endfor %}

update_ip_config:
    salt.state:
      - sls: states.update_nic_config
      - tgt: {{ target_minion_name }}
      - pillar:
          target_fqdn: {{ target_fqdn }}
          target_ip: {{ target_ip }}
          interface_name: {{ interface_name|first }}
{% endif %}
