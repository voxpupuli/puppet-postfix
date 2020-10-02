# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [1.10.0](https://github.com/camptocamp/puppet-postfix/tree/1.10.0) (2020-01-23)

[Full Changelog](https://github.com/camptocamp/puppet-postfix/compare/1.9.0...1.10.0)

### Added

- Add the possibility to manage \(or not\) aliases [\#271](https://github.com/camptocamp/puppet-postfix/pull/271) ([Bodenhaltung](https://github.com/Bodenhaltung))
- Convert to PDK [\#270](https://github.com/camptocamp/puppet-postfix/pull/270) ([raphink](https://github.com/raphink))
- Convert params.pp to hiera data [\#269](https://github.com/camptocamp/puppet-postfix/pull/269) ([raphink](https://github.com/raphink))

### Fixed

- Fix manage\_aliases [\#272](https://github.com/camptocamp/puppet-postfix/pull/272) ([raphink](https://github.com/raphink))

## [1.9.0](https://github.com/camptocamp/puppet-postfix/tree/1.9.0) (2019-11-26)

[Full Changelog](https://github.com/camptocamp/puppet-postfix/compare/1.8.0...1.9.0)

### Added

- Upping version dependency on puppet-alternatives [\#260](https://github.com/camptocamp/puppet-postfix/pull/260) ([cubiclelord](https://github.com/cubiclelord))
- Add RedHat 8 support [\#257](https://github.com/camptocamp/puppet-postfix/pull/257) ([zeromind](https://github.com/zeromind))
- Add missing inet\_protocols parameter to the README. [\#254](https://github.com/camptocamp/puppet-postfix/pull/254) ([catay](https://github.com/catay))
- add retry and proxywrite for debian family OSes [\#253](https://github.com/camptocamp/puppet-postfix/pull/253) ([Dan33l](https://github.com/Dan33l))
- Allow `puppetlabs/stdlib` 6.x [\#246](https://github.com/camptocamp/puppet-postfix/pull/246) ([alexjfisher](https://github.com/alexjfisher))
- Add show\_diff parameter to postfix::conffile [\#226](https://github.com/camptocamp/puppet-postfix/pull/226) ([treydock](https://github.com/treydock))

### Fixed

- Add missing Variable for Suse [\#245](https://github.com/camptocamp/puppet-postfix/pull/245) ([cocker-cc](https://github.com/cocker-cc))

## 1.8.0 (2019-04-05)

- Deprecate Puppet 3 support
- Add new config parameter to add configuration from hiera (GH #240)
- Allow Sensitive postfix::hash content (GH #243)
- Add master_bounce_command and master_defer_command (GH #239)
- Schleuder: port invocation syntax to Schleuder 3. (GH #234)
- Allow multiple spaces in postfix::mta::mynetworks  (GH #235)
- Add postfix::mailalias (GH #233)
- Remove legacy instructions on exec paths

## 1.7.0 (2018-11-01)

- Add chroot parameter (GH #170, #224)
- Fix resource dependencies (GH #185)
- Add postfix::service_ensure and postfix::service_enabled parameters (GH #184)
- Fix email address matching for postfix::virtual augeas lens (GH #177)
- Add master_entries parameter (GH #171)
- Add templates for SLES12 SP2 and SP3 (GH #198)
- Install sendmail alternative on RedHat (GH #199)
- Move Exec['newaliases'] to services to it could be run after service restart (GH #205)
- Unbreak sendmail (GH #201)
- Add retry to RedHat master.cf (GH #215)
- Support '+' in canonical maps (GH #222, fix #220)
- Add support for Alpine Linux (GH #213)
- Support multiple destinations in postfix::virtual (#223, fix #164)
- Make transport pattern accept regexp (GH #225, fix #92)
- Ensure that map files are regenerated if removed (GH #228, fix #161)
- Allow puppetlabs-stdlib < 6.0.0 (GH #229)
- Modulesync: update testing harness and add Puppet 6

## 1.6.0 (2017-08-25)

- Fix package name resolution for Debian stretch (GH #179)
- Do not generate postmap when postfix::map ensure is absent (GH #178)
- Add inet_protocol param. (GH #172)
- Create master.cf.SLES11.4.erb (GH #156)
- Allow mydestination to be blank (GH #162)
- Fix hash.pp doc (GH #159)

## 1.5.0 (2016-11-17)

- Fix params validation + specs (GH #154)
- Fix map calling in hash (GH #153)
- Fix the path of the database (GH #149)
- Add a map define to create postfix maps (#138)

## 1.4.0 (2016-08-23)

- Add manage_root_alias parameter to disable
  management of root's mailalias resource (GH #133)
- set mode 0644 for /etc/mailname (GH #142)
- Fix virtual.db and transport.db creation (GH #135, GH #130)
- Add $manage_mailx boolean to control
  whether mailx is managed (GH #143, GH #141)
- Add conffile define (GH #139)
- Fix acceptance tests (GH #144)
- Update test system

## 1.3.1 (2016-03-16)

- Fix tests for Puppet 4

## 1.3.0 (2016-03-15)

- Consistent formating of documentation (GH #125)
- Add ensure class arguments for packages (GH #99)
- Various testing changes/fixes

## 1.2.14 (2015-08-21)

- Use docker for acceptance tests

## 1.2.13 (2015-06-30)

- Fix documentation

## 1.2.12 (2015-06-26)

- Fix strict_variables activation with rspec-puppet 2.2

## 1.2.11 (2015-06-24)

- Add support for SLES 12 and newest openSUSE releases
- Add acceptance test
- Restart postfix instead of reload after package installation (Fixes #90)
- Use RHEL SELinux type for /etc/aliases

## 1.2.10 (2015-06-19)

- Update documentation

## 1.2.9 (2015-05-28)

- Add beaker_spec_helper to Gemfile

## 1.2.8 (2015-05-26)

- Use random application order in nodeset

## 1.2.7 (2015-05-26)

- add utopic & vivid nodesets

## 1.2.6 (2015-05-25)

- Don't allow failure on Puppet 4

## 1.2.5 (2015-05-19)

- Add missing ownership

## 1.2.4 (2015-05-13)

- Add puppet-lint-file_source_rights-check gem

## 1.2.3 (2015-05-12)

- Don't pin beaker

## 1.2.2 (2015-04-27)

- Add nodeset ubuntu-12.04-x86_64-openstack

## 1.2.1 (2015-04-15)

- Use file() function instead of fileserver (way faster)
- Fix issue with ldap-alias map

## 1.2.0 (2015-04-03)

- Allow to pass arrays to postfix::hash::source and postfix::hash::content
- IPv6 support
- Fix for RedHat
- Add RedHat 7 support
- Use rspec-puppet-facts for unit tests

## 1.1.1 (2015-03-24)

- Various spec improvements

## 1.1.0 (2015-02-19)

- Various specs improvements
- Fix specs for postfix::config with ensure => blank
- Simplify relationships and avoid spaceship operators
- nexthop parameter is not necessary for postfix::canonical

## 1.0.5 (2015-01-07)

- Fix unquoted strings in cases

## 1.0.2 (2014-11-17)

- Add missing postfix_canonical lens to postfix::augeas (GH #59)
- Fix unit tests for RH 7

## 1.0.1 (2014-10-20)

- Setup automatic Forge releases


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
