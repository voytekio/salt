{% set roles = salt['grains.get']('vroles', ['none']) %}
{% set tags = salt['grains.get']('vtags', 'none') %}
{% set use_superseded_syntax = salt['config.get']('use_superseded', ['none']) %}

{% if 'module.run' in use_superseded_syntax %}
list_attribs_NEW_syntax:
  module.run:
    - test.arg:
      - "roles are: {{ roles }}"
      - "tags are: {{ tags }}"
{% else %}
list_attribs_OLD_syntax:
  module.run:
    - name: test.arg
    - args:
        - "roles are: {{ roles }}"
        - "tags are: {{ tags }}"
{% endif %}


managed_dir_installers:
  file.directory:
    - name: /installers
{% if grains['kernel'] == 'Linux' %}
    - user: root
    - group: root
    - mode: 755
{% endif %}

managed_dir_installers_backup:
  file.directory:
    - name: /installers/backup
{% if grains['kernel'] == 'Linux' %}
    - user: root
    - group: root
    - mode: 755
{% endif %}

{% if 'salt_master' in roles %}
say_we_are_a_master:
  module.run:
    - test.arg:
      - "i'm a master"
{% endif %}

{% if 'salt_master' not in roles %}
  {% if 'module.run' in use_superseded_syntax %}
say_we_are_NOT_a_master_NEW_syntax:
  module.run:
    - test.arg:
      - "not a master"
  {% else %}
say_we_are_NOT_a_master_OLD_syntax:
  module.run:
    - name: test.arg
    - args:
        - "not a master"
  {% endif %}

configure_minion_file:
  file.managed:
    - name: /etc/salt/minion.d/v_defaults.conf
    - source: salt://files/templates/minion_v_defaults.conf
    - template: jinja
  {% if grains['kernel'] == 'Linux' %}
    - user: root
    - group: root
    - mode: 644
  {% endif %}

restart_delayed:
  module.run:
    - name: cmd.run
    - cmd: '/bin/bash -c "at now +3 minute <<< \"service salt-minion restart\""'
    - python_shell: True
    - onchanges:
      - file: /etc/salt/minion.d/v_defaults.conf

{% endif %}
