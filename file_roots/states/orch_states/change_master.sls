{% set target = salt.pillar.get('target') %}
{% set target_master = salt.pillar.get('target_master') %}
{% set skip_key_delete_on_master = salt.pillar.get('skip_key_delete_on_master', False) %}
{#
TITLE: write orch to easily move to dev master
IDEA: everytime you work in salt lab, do one step.
TODO: we wrote a state w/ first 3 operations
    now add an orch that 1) runs the state and 2) deletes the key from master

vars:
    - master to move to
    - skip delete keys with salt-key?

steps:
    DONE: - edit line with 'master' in /etc/salt/minion
    DONE: - rm pki/minion_minion_master.pub
    DONE: - in 1 minute:
        systemctl restart salt-minion
    - delete the key from source master with salt-key
#}

repoint_master:
  file.line:
    - name: /etc/salt/minion
    - mode: replace
    - match: "^master:"
    - content: "master: {{ target_master }}"

del_minion_master_key:
  file.absent:
    - name: /etc/salt/pki/minion/minion_master.pub

schedule_restart:
    cmd.run:
      - name: 'echo "systemctl restart salt-minion" | at now + 1 minutes'
