git_sync_voytek_salt:
{% set stage = salt['grains.get']('vtags:stage', 'not_set') %}
  git.latest:
    - name: https://github.com/voytekio/voytek-salt.git
    - target: /srv/voytek-salt
{% if 'qa' in stage or 'dev' in stage %}
{# we're a bit redundant here - rev and branch but per git.latest docs that's expected #}
    - rev: develop
    - branch: develop
{% else %}
    - rev: master
    - branch: master
{% endif %}
{#    - force_reset: True #}

sync_all_on_changes:
  module.run:
    - saltutil.sync_all:
    - onchanges:
      - git: git_sync_voytek_salt

always_succeeds:
  test.succeed_without_changes:
    - name: foo

