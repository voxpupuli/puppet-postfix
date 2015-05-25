## 2015-05-25 - Release 1.2.6

Don't allow failure on Puppet 4

## 2015-05-19 - Release 1.2.5

Add missing ownership

## 2015-05-13 - Release 1.2.4

Add puppet-lint-file_source_rights-check gem

## 2015-05-12 - Release 1.2.3

Don't pin beaker

## 2015-04-27 - Release 1.2.2

Add nodeset ubuntu-12.04-x86_64-openstack

## 2015-04-15 - Release 1.2.1

Use file() function instead of fileserver (way faster)
Fix issue with ldap-alias map

## 2015-04-03 - Release 1.2.0

Allow to pass arrays to postfix::hash::source and postfix::hash::content
IPv6 support
Fix for RedHat
Add RedHat 7 support
Use rspec-puppet-facts for unit tests

## 2015-03-24 - Release 1.1.1

Various spec improvements

## 2015-02-19 - Release 1.1.0

Various specs improvements
Fix specs for postfix::config with ensure => blank 
Simplify relationships and avoid spaceship operators
nexthop parameter is not necessary for postfix::canonical

## 2015-01-07 - Release 1.0.5

Fix unquoted strings in cases

## 2014-11-17 - Release 1.0.2

Add missing postfix_canonical lens to postfix::augeas (GH #59)
Fix unit tests for RH 7

## 2014-10-20 - Release 1.0.1

Setup automatic Forge releases
