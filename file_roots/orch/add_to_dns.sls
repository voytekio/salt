{% set target_fqdn = salt.pillar.get('target_fqdn', 'blank_target_fqdn') %}
{% set target_ip = salt.pillar.get('target_ip', 'blank_target_ip') %}
{% set dns_host = salt.pillar.get('dns_host', 'blank_dns_host') %}
{% set zone_file = '/etc/bind/zones/db.v2.com' %}
{% set zone_tempfile = '/etc/bind/zones/db.v2.com-temp' %}
{% set target_hostname = target_fqdn.split('.')[0] %}
{% set skip_dns = salt.pillar.get('skip_dns', False)%}
{% set skip_set_ip_part = salt.pillar.get('skip_set_ip_part', False)%}

start_somewhere:
  salt.function:
    - name: test.retcode 
    - tgt: {{ dns_host}}
    - kwarg:
        code: 0

{% if not skip_dns %}
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
{% endif %}

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
          data: {{ target_hostname }}
 
{% if not skip_set_ip_part %}
update_ip_config:
    salt.state:
      - sls: states.update_nic_config
      - tgt: {{ target_hostname }}
      - pillar:
          target_fqdn: {{ target_fqdn }}
          target_ip: {{ target_ip }}
          target_hostname: {{ target_hostname }}
{% endif %}
