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

* Ubuntu
* Debian
* CentOS
* RedHat
* Alpine
* Fedora
* FreeBSD

## Dependencies
  - [camptocamp-augeas 1.0.0+](https://github.com/camptocamp/puppet-augeas)
  - [puppet-alternatives 2.0.0+](https://github.com/voxpupuli/puppet-alternatives)
  - [puppetlabs-mailalias_core 1.0.5+](https://github.com/puppetlabs/puppetlabs-mailalias_core)
  - [puppetlabs-stdlib 4.13.0+](https://github.com/puppetlabs/puppetlabs-stdlib)

## Puppet

The supported Puppet versions are listed in the [metadata.json](metadata.json)

## REFERENCES

Please see [REFERENCE.md](https://github.com/voxpupuli/puppet-postfix/blob/master/REFERENCE.md) for more details.

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/voxpupuli/puppet-postfix/issues).

For pull requests, it is very much appreciated to check your Puppet manifest
with [puppet-lint](http://puppet-lint.com/) to follow the recommended Puppet style guidelines from the
[Puppet Labs style guide](http://docs.puppetlabs.com/guides/style_guide.html).


## Transfer Notice

This plugin was originally authored by [Camptocamp](http://www.camptocamp.com).
The maintainer preferred that Puppet Community take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here instead of Camptocamp.

Previously: https://github.com/camptocamp/puppet-postfix
