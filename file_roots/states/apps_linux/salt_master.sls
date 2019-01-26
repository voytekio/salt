git_sync_voytek_salt:
{% set stage = salt['grains.get']('vtags:stage', False) %}
  git.latest:
    - name: https://github.com/voytekio/voytek-salt.git
    - target: /srv/voytek-salt
{% if stage %}
    - rev: develop
{% else %}
    - rev: master
{% endif %}
{#    - force_reset: True #}
