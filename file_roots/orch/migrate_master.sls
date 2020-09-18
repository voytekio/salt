{% set target = salt.pillar.get('target') %}
{% set new_master = salt.pillar.get('new_master') %}
{% set skip_key_delete_on_master = salt.pillar.get('skip_key_delete_on_master', False) %}

{# go to the minion, change master in config file and delete local minion_master key #}
change_master_settings_on_minion:
  salt.state:
    - sls: states.orch_states.change_master
    - tgt: {{ target }}
    - pillar:
       target: {{ target }}
       new_master: {{ new_master }}

{# go to the master and delete the minions key #}
{% if not skip_key_delete_on_master %}
delete_{{ target }}_key_on_source_salt_master:
  salt.wheel:
    - name: key.delete
    - match: {{ target }}
    - require:
      - salt: change_master_settings_on_minion
{% endif %}

inform_user_that_they_need_to_wait:
  module.run:
    - test.arg:
      - "minion will restart in 1 minute to pick up new master"
    - require:
      - salt: change_master_settings_on_minion
