install-icinga2_web_pkgs:
  pkg.installed:
    - pkgs:
      - icingaweb2
      - libapache2-mod-php5
      - icingacli

install-icinga2_php_pkgs:
  pkg.installed:
    - pkgs:
      - php5-imagick
      - php5-gd
      - php5-pgsql

replace_date_in_php_ini:
  file.line:
    - name: /etc/php5/apache2/php.ini
    - match: ';date.timezone ='
    - mode: replace
    - content: 'date.timezone = America/New_York'
    - require:
      - pkg: install-icinga2_php_pkgs

restart_apache:
  cmd.run:
    - name: service apache2 restart
    - onchanges:
      - file: replace_date_in_php_ini

generate_icinga2_web_token:
  cmd.run:
    - name: icingacli setup token create
    - onchanges::
      - cmd: restart_apache
