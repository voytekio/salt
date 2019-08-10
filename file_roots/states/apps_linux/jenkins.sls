{% set hostname = salt['grains.get']('id','error') %}

{# 
TODO: quit if not Ubuntu 16 or more recent
#}

{% set prereq_list = ['openjdk-8-jre'] %}
{% for one_pkg in prereq_list %}
install-{{ one_pkg }}-pkg:
  pkg.installed:
    - name: {{ one_pkg }}
{% endfor %}

java_path_env_variable:
  file.append:
    - name: /etc/environment
    - text: 'JAVA_HOME="/usr/bin/java"'

java_path_source_it:
  cmd.run:
    - name: source /etc/environment
    - shell: /bin/bash
    - onchanges:
      - file: java_path_env_variable

add-jenkins-repo:
  pkgrepo.managed:
    - humanname: jenkins-repo-human-name
    - name: deb https://pkg.jenkins.io/debian-stable binary/
    - file: /etc/apt/sources.list.d/jenkins.list
    - key_url: https://pkg.jenkins.io/debian/jenkins.io.key

install-jenkins-pkg:
  pkg.installed:
    - name: jenkins
    - require:
        - pkgrepo: add-jenkins-repo
