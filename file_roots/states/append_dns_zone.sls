{% set fqdn = salt.pillar.get('target_fqdn', 'blank_fqdn') %}
{% set ip = salt.pillar.get('target_ip', 'blank_ip') %}
{% set source_file_location = salt.pillar.get('source_file_location', 'blank_source') %}
{% set destination_file_location = salt.pillar.get('destination_file_location', 'blank_destination') %}

make_temp_copy:
  file.copy:
    - name: {{ destination_file_location }}
    - source: {{ source_file_location }}
    - force: True

{% if fqdn != 'blank_fqdn' %}
append_dns_zone_file:
  file.append:
    - name: {{ destination_file_location }}
    - text: {{fqdn}}. IN A  {{ip}}
    - require:
        - file: make_temp_copy
{% endif %}
