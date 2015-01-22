# Postfix Puppet Module

[![Puppet Forge Version](http://img.shields.io/puppetforge/v/camptocamp/postfix.svg)](https://forge.puppetlabs.com/camptocamp/postfix)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/camptocamp/postfix.svg)](https://forge.puppetlabs.com/camptocamp/postfix)
[![Build Status](https://img.shields.io/travis/camptocamp/puppet-postfix/master.svg)](https://travis-ci.org/camptocamp/puppet-postfix)
[![Gemnasium](https://img.shields.io/gemnasium/camptocamp/puppet-postfix.svg)](https://gemnasium.com/camptocamp/puppet-postfix)
[![By Camptocamp](https://img.shields.io/badge/by-camptocamp-fb7047.svg)](http://www.camptocamp.com)

This module requires Augeas.

## Simple usage

    include postfix

    postfix::config { "relay_domains": value  => "localhost host.foo.com" }

## Exec paths

In order to not have any path problem, you should add the following line in
some globally included .pp file:

    Exec {
      path => '/some/relevant/path:/some/other:...',
    }

For example:

    Exec {
      path => '/bin:/sbin:/usr/sbin:/usr/bin',
    }

## Classes

### postfix

The top-level class, to install and configure Postfix.

#### Parameters

##### `alias_maps`

A string defining the location of that alias map file.
Default: 'hash:/etc/aliases'

##### `inet_interfaces`

A string defining the network interfaces that Postfix will listen on.
Default: 'all'
Example: '127.0.0.1, [::1]'

##### `ldap`

A boolean defining whether to configure Postfix for LDAP use.
Default: false

##### `ldap_base`

A string defining the LDAP search base to use. This maps to the search_base parameter (ldap_table(5)). 
Default: Undefined. 
Example 'cn=Users,dc=example,dc=com'

##### `ldap_host`

A string defining the LDAP host. This maps to the server_host parameter (ldap_table(5)).
Default: Undefined.
Example: 'ldaps://ldap.example.com:636 ldap://ldap2.example.com'

##### `ldap_options`

A 
Default: Undefined.
Example: 

##### `mail_user`

A string defining the mail user, and optionally group, to execute external commands as. This maps to the user parameter (pipe(8)).
Default: 'vmail'.
Example: 'vmail:vmail'

##### `mailman`

A boolean defining whether to configure a basic smtp server that is able to work for the mailman mailing list manager.
Default: false.

##### `maincf_source`

A string defining the location of a skeleton main.cf file to be used. The default file supplied is blank. However, if the main.cf file already exists on the system the contents will NOT be replaced by the contents from maincf_source.
Default: "puppet:///modules/${module_name}/main.cf"
Example: "puppet:///modules/some/other/location/main.cf"

##### `manage_conffiles`

A boolean defining whether the puppet module should replace the configuration files for postfix. 
This setting currently effects the following files:
* /etc/mailname
* /etc/postfix/master.cf
This setting does NOT effect the following files:
* /etc/aliases
* /etc/postfix/main.cf

Default: true.

##### `mastercf_source`
A string defining the location of a skeleton master.cf file to be used.
Default: Undefined.
Example: "puppet:///modules/some/other/location/master.cf"

##### `master_smtp`
A string to define the smtp line in the /etc/postfix/master.cf file. If this is defined the smtp_listen parameter will be ignored.
Default: Undefined.
Example: 'smtp      inet  n       -       n       -       -       smtpd'

##### `master smtps`
A string to define the smtps line in the /etc/postfix/master.cf file.
Default: Undefined.
Example: 'smtps     inet  n       -       n       -       -       smtpd'

##### `master_submission`
A string to define the submission line in the /etc/postfix/master.cf file.
Default: Undefined.
Example: 'submission inet n       -       n       -       -       smtpd'

##### `mta`
A boolean to define whether to configure Postfix as a mail transfer agent. This option is mutually exclusive with the satellite boolean.
Default: False.

##### `mydestination`
A string to define the mydestination parameter in main.cf (postconf(5)).
Default: The systems FQDN.
Example: 'example.com, foo.example.com'

##### `mynetworks`
A string to define the mynetworks parameter that holds trusted remote smtp clients (postconf(5)).
Default: '127.0.0.0/8'
Example: '127.0.0.0/8, [::1]/128'

##### `myorigin`
A string to define the myorigin parameter that holds the domain name that mail appears to come from (postconf(5)).
Default: The systems FQDN.
Example: 'example.com'

##### `relayhost`
A string to define the relayhost parameter (postconf(5)).
Default: Undefined.
Example: 'smtp.example.com'

##### `root_mail_recipient`
A string to define the e-mail address to which all mail directed to root should go (aliases(5)).
Default: 'nobody'
Example: 'root_catch@example.com'

##### `satellite`
A boolean to define whether to configure postfix as a sattellite relay host. This setting is mutually exclusive with the mta boolean.
Default: False.

##### `smtp_listen`
A string to define the IP on which to listen in the master.cf. This can also be set to 'all' to listen on all interfaces. If master_smtp is defined smtp_listen will not be used.
Default: '127.0.0.1'
Example: '::1'

##### `use_amavisd`
A boolean to define whether to configure master.cf to allow the use of the amavisd scanner.
Default: False.

##### `use_dovecot_lda`
A boolean to define whether to configure master.cf to use dovecot as the local delivery agent.
Default: False.

##### `use_schleuder`
A boolean to define whether to configure master.cf to use the Schleuder gpg-enabled mailinglist.
Default: False.

##### `use_sympa`
A boolean to define whether to configure master.cf to use the Sympa mailing list management software.
Default: False.

#### Examples

### postfix::config

Add/alter/remove options in Postfix main configuration file (main.cf). This uses augeas to do the editing of the confiugration file, as such any configuration value can be used.

#### Parameters

##### `ensure`
A string whose value can be any of 'present', 'absent', 'blank'.
Default: 'present'
Example: 'blank'

##### `value`
A string that can contain any text to be used as the configuration value.
Default: Undefined.
Example: 'btree:${data_directory}/smtp_tls_session_cache'

#### Examples
##### Configure Postfix to use TLS as a client
```
postfix::config {
    'smtp_tls_mandatory_ciphers':       value   => 'high';
    'smtp_tls_security_level':          value   => 'secure';
    'smtp_tls_CAfile':                  value   => '/etc/pki/tls/certs/ca-bundle.crt';
    'smtp_tls_session_cache_database':  value   => 'btree:${data_directory}/smtp_tls_session_cache';
}
```

##### Configure Postfix to disable the vrfy command
```
postfix::config { 'disable_vrfy_command':
    ensure  => present,
    value   => 'yes',
}
```

### postfix::hash
Creates Postfix hashed "map" files, and builds the corresponding db file.

#### Parameters

##### `ensure`
Defines whether the hash map file is present or not. Value can either be present or absent.
Default: present.
Example: absent.

##### `content`
A free form string that defines the contents of the file. This parameter is mutually exclusive to the source parameter.
Default: Undefined.
Example: '#Destination                Credentials\nsmtp.example.com            gssapi:nopassword'

##### `source`
A string whose value is a location for the source file to be used. This parameter is mutually exclusive with the content parameter, one or the other must be present, but both cannot be present.
Default: Undefined
Example: 'puppet:///modules/some/location/sasl_passwd'

#### Examples
##### Create a sasl_passwd hash from a source file
```
postfix::hash { '/etc/postfix/sasl_passwd':
    ensure  => 'present',
    source  => 'puppet:///modules/profile/postfix/client/sasl_passwd',
}
```
##### Create a sasl_passwd hash with contents defined in the manifest
```
postfix::hash { '/etc/postfix/sasl_passwd':
    ensure  => 'present',
    content => '#Destination                Credentials\nsmtp.example.com            gssapi:nopassword',
}
```
### postfix::transport

Manages content of the /etc/postfix/transport map.

#### Parameters

##### `ensure`
Defines whether the transport entry is presnet or not. Value can either be present or absent.
Default: present.
Example: absent.

##### `destination`
The destinationa to be delivered to (transport(5)).
Default: Undefined.
Example: 'mailman'

##### `nexthop`


### postfix::virtual

Manages content in the virtual map.


