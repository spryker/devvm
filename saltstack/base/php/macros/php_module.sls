#
# Macro: Enable or disable PHP module
#

{% macro php_module(name, enable, sapi) -%}
{% if enable %}
enable-php-module-{{ name }}-for-{{ sapi }}:
  cmd.run:
    - name: phpenmod -v 7.1 -s {{ sapi }} {{ name }}
    - unless: phpquery -v 7.1 -s {{ sapi }} -m {{ name }}
    - require:
      - file: /etc/php/7.1/mods-available/{{ name }}.ini
{% else %}
disable-php-module-{{ name }}-for-{{ sapi }}:
  cmd.run:
    - name: phpdismod -v 7.1 -s {{ sapi }} {{ name }}
    - onlyif: phpquery -v 7.1 -s {{ sapi }} -m {{ name }}
{% endif %}

{% endmacro %}
