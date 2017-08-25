## 2017-08-25 - Release 1.6.0

- Fix package name resolution for Debian stretch (GH #179)
- Do not generate postmap when postfix::map ensure is absent (GH #178)
- Add inet_protocol param. (GH #172)
- Create master.cf.SLES11.4.erb (GH #156)
- Allow mydestination to be blank (GH #162)
- Fix hash.pp doc (GH #159)

## 2016-11-17 - Release 1.5.0

- Fix params validation + specs (GH #154)
- Fix map calling in hash (GH #153)
- Fix the path of the database (GH #149)
- Add a map define to create postfix maps (#138)

## 2016-08-23 - Release 1.4.0

- Add manage_root_alias parameter to disable
  management of root's mailalias resource (GH #133)
- set mode 0644 for /etc/mailname (GH #142)
- Fix virtual.db and transport.db creation (GH #135, GH #130)
- Add $manage_mailx boolean to control
  whether mailx is managed (GH #143, GH #141)
- Add conffile define (GH #139)
- Fix acceptance tests (GH #144)
- Update test system

## 2016-03-16 - Release 1.3.1

- Fix tests for Puppet 4

## 2016-03-15 - Release 1.3.0

- Consistent formating of documentation (GH #125)
- Add ensure class arguments for packages (GH #99)
- Various testing changes/fixes

## 2015-08-21 - Release 1.2.14

Use docker for acceptance tests

## 2015-06-30 - Release 1.2.13

Fix documentation

## 2015-06-26 - Release 1.2.12

Fix strict_variables activation with rspec-puppet 2.2

## 2015-06-24 - Release 1.2.11

Add support for SLES 12 and newest openSUSE releases
Add acceptance test
Restart postfix instead of reload after package installation (Fixes #90)
Use RHEL SELinux type for /etc/aliases

## 2015-06-19 - Release 1.2.10

Update documentation

## 2015-05-28 - Release 1.2.9

Add beaker_spec_helper to Gemfile

## 2015-05-26 - Release 1.2.8

Use random application order in nodeset

## 2015-05-26 - Release 1.2.7

add utopic & vivid nodesets

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
