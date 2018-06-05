change_locale_to_utf8:
  cmd.run:
    #- name: locale-gen "en_US.UTF-8"
    - name: export LANG=en_US.utf8

install-postgresql-pkg:
  pkg.installed:
    - name: postgresql
    - require:
      - cmd: change_locale_to_utf8
