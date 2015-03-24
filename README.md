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

## Definitions

### postfix::config

Add/alter/remove options in Postfix main configuration file (main.cf)

### postfix::hash

Creates Postfix hashed "map" files, and build the corresponding db file.

### postfix::transport

Manages content in the transport map.

### postfix::virtual

Manages content in the virtual map.


