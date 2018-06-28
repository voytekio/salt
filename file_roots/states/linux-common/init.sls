managed_vimrc_root:
  file.managed:
    - name: /root/.vimrc
    - source: salt://files/linux-common/.vimrc
    - user: root
    - group: root
    - mode: 644

{% set osvar = grains['os'] %}
managed_sudoers:
  file.managed:
    - name: /etc/sudoers
    - source: salt://files/linux-common/sudoers-{{osvar}}
    - user: root
    - group: root
    - mode: 440

managed_etc_hostname:
    file.managed:
      - name: /etc/hostname
      - mode: 644
      - source: salt://files/linux-common/hostname
      - template: jinja
      - user: root
      - group: root

{% set hname = grains['id'] %}
replaced_etc_hosts:
    file.line:
      - name: /etc/hosts
      - match: '127.0.1.1'
      - mode: replace
      - content: '127.0.1.1    {{ hname }}.v2.com  {{ hname }}'

update_hostname_in_memory:
    cmd.run:
      - name: service hostname start
      - onchanges:
        - replaced_etc_hosts

{% for one_pkg in ['at','vim','curl','python-pip'] %}
install_pkgs_{{ one_pkg }}:
  pkg.installed:
    - name: {{ one_pkg }}
{% endfor %}

create_reboot_file_for_at:
  file.managed:
    - name: /installers/at-reboot.sh
    - contents: 'reboot'
    - mode: 644
    - user: root
    - group: root

