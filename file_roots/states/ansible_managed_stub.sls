{% set version = salt['grains.get']('saltversion', '2016.1.1') %}
{% set use_superseded_syntax = salt['config.get']('use_superseded', ['none']) %}

{% if '2016' in version or 'module.run' not in use_superseded_syntax %}
log_message_OLD_syntax:
  module.run:
    - name: log.info
    - message: "This host has Ansible tag so we'll not manage it through Salt"
{% else %}
log_message_NEW_syntax:
  module.run:
    - log.info:
      - message: "This host has Ansible tag so we'll not manage it through Salt"
{% endif %}
