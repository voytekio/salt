{% set vroles_a = salt['grains.get']('vroles','') %}
{% if vroles_a %}
include:
{% for one_app in vroles_a %}
  - .{{ one_app }}
{% endfor %}
{% endif %}
