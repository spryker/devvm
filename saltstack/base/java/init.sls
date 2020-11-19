#
# Install Java Runtime Environment - OpenJDK version 8
#

ca-certificates-java:
  pkg.latest:
    - fromrepo: {{ grains.lsb_distrib_codename }}-backports
    - refresh: False

java:
  pkg.installed:
    - name: adoptopenjdk-8-hotspot
    - require:
      - pkg: ca-certificates-java
  alternatives.set:
    - name: java
    - path: /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
    - require:
      - pkg: adoptopenjdk-8-hotspot
