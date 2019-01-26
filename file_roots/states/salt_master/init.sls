git_sync_voytek_salt:
  git.latest:
    - name: https://github.com/voytekio/voytek-salt.git
    - target: /srv
{% if grains['vtags']['stage'] == 'qa' %}
    - rev: develop
{% else %}
    - rev: master
{% endif %}
{#    - force_reset: True #}
