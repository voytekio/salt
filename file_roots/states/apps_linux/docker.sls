{% set os_var = grains['os'] %}
{% set os_majorrelease_var = grains['osmajorrelease'] %}

check_os_for_docker:
{% if 'Ubuntu' not in os_var %}
  test.fail_without_changes:
    - name: only Ubuntu supported for now
{% elif os_majorrelease_var < 18 %}
  test.fail_without_changes:
    - name: os_majorrelease must be 18 or greater
{% else %}
  test.succeed_without_changes:
    - name: os checks passed
{% endif %}

{# this hardcodes bionic into the repo #}
add-docker-repo:
  pkgrepo.managed:
    - humanname: docker-repo-human-name
    - name: deb https://download.docker.com/linux/ubuntu bionic stable
    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/ubuntu/gpg

{#
schedule_update:
    cmd.run:
      - name: 'apt-get update'
      - onchanges:
        - pkgrepo: add-docker-repo
#}

install_docker_packages:
  pkg.installed:
    - pkgs:
        - docker-ce
        - docker-ce-cli
        - containerd.io
    - require:
      - pkgrepo: add-docker-repo

group_jenkinsuser_into_docker_group:
  user.present:
    - name: jenkins
    - groups:
        - docker
    - require:
      - pkg: install_docker_packages


