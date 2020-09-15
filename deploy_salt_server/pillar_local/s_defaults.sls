{% set stage = salt['grains.get']('vtags:stage', 'not_set') %}
salt:
  install_packages: False
  master:
    file_roots:
      base:
        - /srv/salt-dev/voytek-salt/file_roots
        - /srv/voytek-salt/file_roots
        - /srv/salt-no-github
        - /srv/salt-formula
        - /srv/salt
    log_level_logfile: info
    auto_accept: True
  minion_remove_config: True
  minion:
    master: localhost
{% if 'dev' not in stage %}
    schedule:
      - highstate:
        - function: state.highstate
        - minutes: 30
{% endif %}
    log_level_logfile: info
    use_superseded:
      - module.run
    grains:
      vroles:
        - salt_master
