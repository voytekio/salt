salt:
  master:
    file_roots:
      base:
        - /srv/salt-dev
        - /srv/voytek-salt/file_roots
        - /srv/salt-no-github
        - /srv/salt-formula
        - /srv/salt
    log_level_logfile: info
