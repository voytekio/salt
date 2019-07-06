{% set hostname = salt['grains.get']('id','error') %}

{% set prereq_list = ['python-dev', 'libcairo2-dev', 'libffi-dev', 'build-essential', 'nginx'] %}
{% for one_pkg in prereq_list %}
install-{{ one_pkg }}-pkg:
  pkg.installed:
    - name: {{ one_pkg }}
{% endfor %}

upgrade_pip:
  pip.installed:
    - name: pip
    - upgrade: True
    - ignore_installed: True
    - onchanges:
      - pkg: install-libcairo2-dev-pkg

upgrade_setuptools:
  pip.installed:
    - name: setuptools
    - upgrade: True

setup_python_path:
  cmd.run:
    - name: export PYTHONPATH="/opt/graphite/lib/:/opt/graphite/webapp/"
    - onchanges:
      - pip: upgrade_pip

install_whisper_db:
  pip.installed:
    - name: https://github.com/graphite-project/whisper/tarball/master
    - no_binary: ':all:'
    - onchanges:
      - cmd: setup_python_path

install_carbon:
  pip.installed:
    - name: https://github.com/graphite-project/carbon/tarball/master
    - no_binary: ':all:'
    - onchanges:
      - cmd: setup_python_path

install_webapp:
  pip.installed:
    - name: https://github.com/graphite-project/graphite-web/tarball/master
    - no_binary: ':all:'
    - onchanges:
      - cmd: setup_python_path

install_gunicorn:
  pip.installed:
    - name: gunicorn

upgrade_six:
  pip.installed:
    - name: six
    - upgrade: True
    - ignore_installed: True
    - onchanges:
      - cmd: setup_python_path

setup_sqllite_db:
  cmd.run:
    - name: PYTHONPATH=/opt/graphite/webapp django-admin.py migrate --settings=graphite.settings --run-syncdb
    - onchanges:
      - pip: install_webapp


setup_touch1:
  cmd.run:
    - name: touch /var/log/nginx/graphite.access.log
    - onchanges:
      - pip: install_webapp

setup_touch_2:
  cmd.run:
    - name: touch /var/log/nginx/graphite.error.log
    - onchanges:
      - pip: install_webapp

setup_chmod_1:
  cmd.run:
    - name: chmod 640 /var/log/nginx/graphite.*
    - onchanges:
      - pip: install_webapp

setup_chmod_2:
  cmd.run:
    - name: chown www-data:www-data /var/log/nginx/graphite.*
    - onchanges:
      - pip: install_webapp

configure_nginx_graphite_file:
  file.managed:
    - name: /etc/nginx/sites-available/graphite
    - source: salt://files/templates/graphite_nginx.conf
    - template: jinja
    - context:
      hostname: {{ hostname }}

{#link_1:
  cmd.run:
    - name: ln -s /etc/nginx/sites-available/graphite /etc/nginx/sites-enabled
#}

link_2:
  file.symlink:
    - name: /etc/nginx/sites-enabled/graphite
    - target: /etc/nginx/sites-available/graphite

file_not_exist:
  file.absent:
    - name: /etc/nginx/sites-enabled/default

reload_nginx:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/sites-available/graphite

conf_file_carbon_main:
  file.managed:
    - name: /opt/graphite/conf/carbon.conf
    - source: salt://files/templates/graphite_carbon.conf
    - template: jinja

conf_file_carbon_storage-schemas:
  file.managed:
    - name: /opt/graphite/conf/storage-schemas.conf
    - source: salt://files/templates/graphite_carbon_storage-schemas.conf
    - template: jinja

log_test_1_5:
  module.run:
    - name: test.arg
    - args: 
        - "gotta start somewhere 1.5"
{#
    - require:
      - cmd: change_locale_to_utf8
#}

