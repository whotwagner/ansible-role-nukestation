# Ansible Role: nukestation

This role installs nwipe on Debian and places a udev-rule so that plugged usb-storages will be wiped automatically.

## Requirements

- Ansible 2.1+ (might ork with prior versions too)
- Debian-based linux-distribution

## Playbook Examples

This role can be configured in two ways:

 * Simple configuration without notifications
 * Configuration with Postfix + Authentication 

### Simple configuration without mail-support

The following playbook will install a simple nukestation-configuration. Notifications are disabled in this setup.

```
---
- hosts: localhost
  roles:
        - nukestation
```

### Install nukestation with authentication mailrelay:

The following playbook will install nukestation together with a freshly installed postfix. All parameters are required to make this configuration working.

```
- hosts: localhost
  roles:
        - nukestation
  vars:
        nukestation_mailconf:
                server: mail.example.conf:587
                user: username@example.conf
                pass: super-secret-password
                from: from@example.com
                to: to@example.com

```


# Licence

GPL

# Author information

This role was created in 2018 by [Wolfgang Hotwagner](https://tech.feedyourhead.at)

