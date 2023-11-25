# Postfix Puppet Module

[![License](https://img.shields.io/github/license/voxpupuli/puppet-postfix.svg)](https://github.com/voxpupuli/puppet-postfix/blob/master/LICENSE)
[![Puppet Forge Version](http://img.shields.io/puppetforge/v/puppet/postfix.svg)](https://forge.puppetlabs.com/puppet/postfix)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/puppet/postfix.svg)](https://forge.puppetlabs.com/puppet/postfix)
[![Build Status](https://github.com/voxpupuli/puppet-postfix/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-postfix/actions?query=workflow%3ACI)
[![Donated by Camptocamp](https://img.shields.io/badge/donated%20by-camptocamp-fb7047.svg)](#transfer-notice)

## Features

* Configure postfix as mta or satellite
* Support for amavis scanner config
* Dovecot as the local delivery agent config
* Support Schleuder GPG-enabled mailing list
* Sympa mailing list management software
* Support for mailman
* Support for LDAP

## Supported OS

See [metadata.json](metadata.json) for supported OS versions.

## Dependencies

See [metadata.json](metadata.json) for dependencies.

## Puppet

The supported Puppet versions are listed in the [metadata.json](metadata.json)

## REFERENCES

Please see [REFERENCE.md](https://github.com/voxpupuli/puppet-postfix/blob/master/REFERENCE.md) for more details.

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/voxpupuli/puppet-postfix/issues).

For pull requests, it is very much appreciated to check your Puppet manifest
with [puppet-lint](https://github.com/puppetlabs/puppet-lint/) to follow the recommended Puppet style guidelines from the
[Puppet Labs style guide](https://www.puppet.com/docs/puppet/latest/style_guide.html).


## Transfer Notice

This plugin was originally authored by [Camptocamp](http://www.camptocamp.com).
The maintainer preferred that Puppet Community take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here instead of Camptocamp.

Previously: https://github.com/camptocamp/puppet-postfix
