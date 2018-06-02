{% set target_fqdn = salt.pillar.get('target_fqdn', 'blank_target_fqdn') %}
{% set target_ip = salt.pillar.get('target_ip', 'blank_target_ip') %}
{% set zone_file = '/etc/bind/zones/db.v2.com' %}
{% set zone_tempfile = '/etc/bind/zones/db.v2.com-temp' %}
{% set target_hostname = target_fqdn.split('.')[0] %}
{% set skip_dns = salt.pillar.get('skip_dns', False)%}

start_somewhere:
  salt.function:
    - name: test.retcode 
    - tgt: router5
    - kwarg:
        code: 0

{% if skip_dns == False %}
append_temp_zone_file:
  salt.state:
    - sls: states.append_dns_zone
    - tgt: router5
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
    - tgt: router5
    - kwarg:
        cmd: 'named-checkzone v2.com {{ zone_tempfile }}'
    - onchanges:
        - salt: append_temp_zone_file

update_real_zone_file:
  salt.state:
    - sls: states.append_dns_zone
    - tgt: router5
    - pillar:
        source_file_location: {{ zone_tempfile }}
        destination_file_location: {{ zone_file }}
    - onchanges:
        - salt: test_new_zonefile

restart_bind:
  salt.function:
    - tgt: router5
    - name: service.restart
    - arg: 
        - bind9
    - onchanges:
        - salt: update_real_zone_file

log_some_output:
    salt.function:
      - name: test.outputter
      - tgt: router5
      - kwarg:
          data: {{ target_hostname }}
 
update_ip_config:
    salt.state:
      - sls: states.update_nic_config
      - tgt: {{ target_hostname }}
      - pillar:
          target_fqdn: {{ target_fqdn }}
          target_ip: {{ target_ip }}
          target_hostname: {{ target_hostname }}
