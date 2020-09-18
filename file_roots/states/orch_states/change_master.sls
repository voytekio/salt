{% set target = salt.pillar.get('target') %}
{% set new_master = salt.pillar.get('new_master') %}

repoint_master:
  file.line:
    - name: /etc/salt/minion
    - mode: replace
    - match: "^master:"
    - content: "master: {{ new_master }}"

del_minion_master_key:
  file.absent:
    - name: /etc/salt/pki/minion/minion_master.pub

schedule_restart:
    cmd.run:
      - name: 'echo "systemctl restart salt-minion" | at now + 1 minutes'
