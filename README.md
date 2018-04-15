# Ansible Role: nukestation

This role installs nwipe on Debian and places a udev-rule so that plugged usb-storages will be wiped automatically.

## Requirements

 * Ansible 2.1+ (might ork with prior versions too)
 * Debian-based linux-distribution(tested with freshly installed Raspbian)

## Configuring Nukestation

nukestation.sh is a simple Script that invokes nwipe. The configuration-files are based at /etc/nukestation. 

### /etc/nukestation/nukestation.conf:

The main-configuration file is located at /etc/nukestation/nukestation.conf. The following Variables can be set:
 * LOGDIR="/var/log/nukestation"
 * ENABLE_MAIL=0
 * MAIL_FROM=root
 * MAIL_TO=root
 * METHOD=dodshort
 * ROUNDS=1

### /etc/nukestation/pre.d:

All shell-scripts with the extension ".conf" that are located in /etc/nukestation/pre.d will be executed before nwipe starts.

### /etc/nukestation/post.d:

All shell-scripts with the extension ".conf" that are located in /etc/nukestation/post.d will be executed after nwipe stopped. 


## Configuration Variables

### nukestation_method

If nukestation_method is not defined the default method will be used. Valid methods are:

 * dod522022m / dod
 * dodshort / dod3pass (default)
 * gutmann
 * ops2
 * random / prng / stream
 * zero / quick

Consider looking into the nwipe-manpage for more information.

### nukestation_rounds

If nukestation_rounds is not defined the default(one round) will be used.

### nukestation_mailconf

If nukestation_mailconf is not defined, no mail-notification will be installed. If nukestation_mailconf is defined postfix will be installed and configured to relay with sasl-authentication. Therefor the following variables are required:

```
  vars: 
       nukestation_mailconf:
                server: mail.example.conf:587
                user: username@example.conf
                pass: super-secret-password
                from: from@example.com
                to: to@example.com

```

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

It's also possible to set the method and/or the rounds:

```
---
- hosts: localhost
  roles:
        - nukestation
  vars:
        nukestation_method: quick
        nukestation_rounds: 2
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

