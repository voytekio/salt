{% set install_dev = salt['pillar.get']('install_dev', False) %}

{% if install_dev %}
{% set prereq_list = ['python3.6', 'python3-distutils', 'python3.6-venv', 'python3.6-dev'] %}
{% else %}
{% set prereq_list = ['python3.6', 'python3-distutils', 'python3.6-venv' ] %}
{% endif %}

log_test_1_5:
  module.run:
    - name: test.arg
    - args:
        - "gotta start somewhere 1.5"

{% if grains['osmajorrelease'] == 14 and 'Ubuntu' in grains['os'] %}
add-python3-deadsnakes-repo_ubuntu_14_only:
  pkgrepo.managed:
    - ppa: deadsnakes/ppa

schedule_update:
    cmd.run:
      - name: 'apt-get update'
      - onchanges:
        - pkgrepo: add-python3-deadsnakes-repo_ubuntu_14_only
{% endif %}

{% for one_pkg in prereq_list %}
install-{{ one_pkg }}-pkg:
  pkg.installed:
    - name: {{ one_pkg }}
{% if grains['osmajorrelease'] == 14 and 'Ubuntu' in grains['os'] %}
    - require:
      - pkgrepo: add-python3-deadsnakes-repo_ubuntu_14_only
{% endif %}
{% endfor %}

fix-symlink:
  file.symlink:
    - name: /usr/bin/python3
    - target: /usr/bin/python3.6


obtain_pip3_status:
  cmd.run:
    - name: pip3 --version

pip3-download:
  cmd.run:
    - name: 'wget https://bootstrap.pypa.io/get-pip.py'
    - onfail:
        - cmd: obtain_pip3_status

pip3-install:
  cmd.run:
    - name: 'python3.6 get-pip.py'
    - onfail:
        - cmd: obtain_pip3_status
    - require:
        - cmd: pip3-download

upgrade_pip:
  pip.installed:
    - name: pip
    - upgrade: True

upgrade_wheel:
  pip.installed:
    - name: wheel
    - upgrade: True

