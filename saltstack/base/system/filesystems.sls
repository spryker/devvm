#
# Automatically format and mount partitions given in grains.filesystems (ext4 filesystem)
#

{% for volume, mount_point in grains.get('filesystems', {}).iteritems() %}
create-fs-{{ volume }}:
  cmd.run:
    - name: mkfs -t ext4 {{ volume }} && tune2fs -o journal_data_writeback {{ volume }} && tune2fs -O ^has_journal {{ volume }} && e2fsck -f -y {{ volume }}
    - onlyif: test -b {{ volume }} && file -sL {{ volume }} | grep -v 'ext[234]'

{{ mount_point }}:
  file.directory:
    - makedirs: True

fstab-for-{{ volume }}:
  file.append:
    - name: /etc/fstab
    - text: {{ volume }}  {{ mount_point }}  ext4  rw,noatime,nodiratime,nobarrier  0 1
    - require:
      - file: {{ mount_point }}
      - cmd: create-fs-{{ volume }}

mount-fs-{{ volume }}:
  cmd.wait:
    - name: mount {{ mount_point }}
    - watch:
      - file: fstab-for-{{ volume }}
    - requires:
      - file: {{ mount_point }}

{% endfor %}

#
# Init and activate swap on devices given in grains
#

{% for path, size in grains.get('swap', {}).items() %}
init-swap-{{ path }}:
  cmd.run:
    - name: dd if=/dev/zero of={{ path }} bs=1048576 count={{ size }} && mkswap {{ path }}
    - unless: test -f {{ path }}

fstab-for-swap-{{ path }}:
  file.append:
    - name: /etc/fstab
    - text: {{ path }} none swap sw 0 0
    - require:
      - cmd: init-swap-{{ path }}

mount-swap-{{ path }}:
  cmd.wait:
    - name: swapon {{ path }}
    - watch:
      - file: fstab-for-swap-{{ path }}

{% endfor %}
