{% set hostname = salt['grains.get']('id','error') %}

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

