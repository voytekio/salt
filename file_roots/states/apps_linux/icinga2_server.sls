# replacing stock initd image is needed due to bug:
# see: minion not returning, apt-get defunct #9736
# https://github.com/saltstack/salt/issues/9736
replace_stock_init_d:
  file.managed:
    - name: /etc/init.d/icinga2
    - source: salt://files/icinga_init_modified
    - mode: 755
    - user: root
    - group: root

install-icinga-pkg:
  pkg.installed:
    - name: icinga2
    - refresh: True
    - require:
        - add-icinga-repo

add-icinga-repo:
  pkgrepo.managed:
    - humanname: icinga-repo-human-name
    - name: deb https://packages.icinga.com/ubuntu icinga-trusty main
    - file: /etc/apt/sources.list.d/icinga.list
    - key_url: https://packages.icinga.com/icinga.key
