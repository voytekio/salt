{% set api_pwd = salt.pillar.get('pwd_icingaweb2', 'None') %}
{% set db_pwd = salt.pillar.get('pwd_icingadb', 'None') %}

include:
  - states.apps_linux.icinga2_server
  - states.apps_linux.postgresql

install-icinga2-ido-pgsql-pkg:
  pkg.installed:
    - name: icinga2-ido-pgsql
    - require:
      - sls: states.apps_linux.postgresql

configure-icinga2-db1:
  cmd.run:
    - name: sudo -u postgres psql -c "CREATE ROLE icinga WITH LOGIN PASSWORD '{{db_pwd}}'"
    - require:
      - pkg: install-icinga2-ido-pgsql-pkg

configure-icinga2-db2:
  cmd.run:
    - name: sudo -u postgres createdb -O icinga icinga
    - require:
      - cmd: configure-icinga2-db1

configure-icinga2-db3:
  cmd.run:
    - name: sudo -u postgres psql -c "CREATE ROLE icingaweb2 WITH LOGIN PASSWORD '{{api_pwd}}'"
    - require:
      - pkg: install-icinga2-ido-pgsql-pkg

configure-icinga2-db4:
  cmd.run:
    - name: sudo -u postgres createdb -O icingaweb2 icingaweb
    - require:
      - cmd: configure-icinga2-db3

manage_pg_hba_conf:
  file.managed:
    - name: /etc/postgresql/9.3/main/pg_hba.conf
    - mode: 640
    - source: salt://files/pg_hba.conf
    - user: postgres
    - group: postgres
    - require:
      - pkg: install-icinga2-ido-pgsql-pkg

restart_postgres:
  cmd.run:
    - name: service postgresql restart
    - onchanges:
      - file: manage_pg_hba_conf

create_icinga2_tables:
  cmd.run:
    - name: 'export PGPASSWORD={{db_pwd}}; psql -U icinga -d icinga < /usr/share/icinga2-ido-pgsql/schema/pgsql.sql'
    - require:
      - cmd: restart_postgres

enable_ido_postgres_module:
  cmd.run:
    - name: icinga2 feature enable ido-pgsql
    - require:
      - cmd: create_icinga2_tables

restart_icinga2:
  cmd.run:
    - name: service icinga2 restart
    - require:
      - cmd: enable_ido_postgres_module

install-apache-pkg:
  pkg.installed:
    - name: apache2
    - require:
      - cmd: enable_ido_postgres_module

setup_icinga2_api:
  cmd.run:
    - name: icinga2 api setup
    - onchanges:
      - pkg: install-apache-pkg

setup_api_users_file_part1:
  file.append:
    - name: /etc/icinga2/conf.d/api-users.conf
    - text:
      - 'object ApiUser "icingaweb2" {'
      - '  password = "{{api_pwd}}"'
      - '  permissions = [ "status/query", "actions/*", "objects/modify/*", "objects/query/*" ]'

setup_api_users_file_part2:
  file.line:
    - name: /etc/icinga2/conf.d/api-users.conf
    - mode: insert
    - location: end
    - content: "}"

restart_icinga2_2:
  cmd.run:
    - name: service icinga2 restart
    - onchanges:
      - file: setup_api_users_file_part2
