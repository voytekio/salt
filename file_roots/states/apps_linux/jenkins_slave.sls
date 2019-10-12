{% set hostname = salt['grains.get']('id','error') %}
{% set os_var = grains['os'] %}
{% set os_majorrelease_var = grains['osmajorrelease'] %}

check_os:
{% if 'Ubuntu' not in os_var %}
  test.fail_without_changes:
    - name: only Ubuntu supported for now
{% elif os_majorrelease_var < 16 %}
  test.fail_without_changes:
    - name: os_majorrelease must be 16 or greater
{% else %}
  test.succeed_without_changes:
    - name: os checks passed
{% endif %}

install-openjdk-8-jre-pkg:
  pkg.installed:
    - name: openjdk-8-jre
    - require:
      - test: check_os

java_path_env_variable:
  file.append:
    - name: /etc/environment
    - text: 'JAVA_HOME="/usr/bin/java"'
    - require:
      - pkg: install-openjdk-8-jre-pkg

java_path_source_it:
  cmd.run:
    - name: source /etc/environment
    - shell: /bin/bash
    - onchanges:
      - file: java_path_env_variable

add_jenkins_user:
  user.present:
    - name: jenkins

ensure_ssh_dir:
    file.directory:
      - name: /home/jenkins/.ssh
      - user: jenkins
      - group: jenkins
      - mode: 700
      - require:
        - user: add_jenkins_user

add_jenkins_master_to_authorized_keys:
    file.managed:
      - name: /home/jenkins/.ssh/authorized_keys
      - source: salt://files/templates/authorized_keys_jenkins_slave
      - mode: 664
      - user: jenkins
      - group: jenkins
      - require:
        - file: ensure_ssh_dir

install_virtenv:
  pip.installed:
    - name: virtualenv

install_tox:
  pip.installed:
    - name: tox

{#
add-jenkins-repo:
  pkgrepo.managed:
    - humanname: jenkins-repo-human-name
    - name: deb https://pkg.jenkins.io/debian-stable binary/
    - file: /etc/apt/sources.list.d/jenkins.list
    - key_url: https://pkg.jenkins.io/debian/jenkins.io.key
    - require:
      - pkg: install-openjdk-8-jre-pkg

install-jenkins-pkg:
  pkg.installed:
    - name: jenkins
    - require:
        - pkgrepo: add-jenkins-repo
#}
