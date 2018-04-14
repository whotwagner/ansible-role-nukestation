# Ansible Role: maradns

This role installs nwipe on Debian and places a udev-rule so that plugged usb-storages will be wiped automatically.

## Requirements

- Ansible 2.1+ (might ork with prior versions too)
- Debian-based linux-distribution

## Configuration example

```
---
- hosts: localhost
  roles:
        - nukestation
```

# Licence

GPL

# Author information

This role was created in 2018 by [Wolfgang Hotwagner](https://tech.feedyourhead.at)

