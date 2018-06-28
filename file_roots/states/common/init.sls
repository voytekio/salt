managed_dir_installers:
  file.directory:
    - name: /installers
{% if grains['kernel'] == 'Linux' %}
    - user: root
    - group: root
    - mode: 755
{% endif %}

managed_dir_installers_backup:
  file.directory:
    - name: /installers/backup
{% if grains['kernel'] == 'Linux' %}
    - user: root
    - group: root
    - mode: 755
{% endif %}
