#
# Install package, remove default service
#

# Here we use specific version of the package to avoid auth issues with Jenkins 2.0
jenkins:
  pkg.installed:
    - hold: True
    - sources:
      - jenkins: http://pkg.jenkins-ci.org/debian-stable/binary/jenkins_1.651.3_all.deb

disable-jenkins-service:
  service.dead:
    - name: jenkins
    - enable: False
    - require:
      - pkg: jenkins

# Make sure that www-data can unpack jenkins war file
/var/cache/jenkins:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 775
    - recurse:
      - user
      - group
    - require:
      - pkg: jenkins
