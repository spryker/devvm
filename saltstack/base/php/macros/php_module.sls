#
# Macro: Enable or disable PHP module
#

{% macro php_module(name, enable, sapi) -%}
{% if enable %}
enable-php-module-{{ name }}-for-{{ sapi }}:
  cmd.run:
    - name: phpenmod -v {{ salt['pillar.get']('php:major_version') }} -s {{ sapi }} {{ name }}
    - unless: phpquery -v {{ salt['pillar.get']('php:major_version') }} -s {{ sapi }} -m {{ name }}
    - require:
      - file: /etc/php/{{ salt['pillar.get']('php:major_version') }}/mods-available/{{ name }}.ini
{% else %}
disable-php-module-{{ name }}-for-{{ sapi }}:
  cmd.run:
    - name: phpdismod -v {{ salt['pillar.get']('php:major_version') }} -s {{ sapi }} {{ name }}
    - onlyif: phpquery -v {{ salt['pillar.get']('php:major_version') }} -s {{ sapi }} -m {{ name }}
{% endif %}

{% endmacro %}
