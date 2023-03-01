# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v3.1.0](https://github.com/voxpupuli/puppet-postfix/tree/v3.1.0) (2023-03-01)

[Full Changelog](https://github.com/voxpupuli/puppet-postfix/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- Add option to select lookup table type [\#336](https://github.com/voxpupuli/puppet-postfix/pull/336) ([timdeluxe](https://github.com/timdeluxe))

**Fixed bugs:**

- Fix typos errors in postfix::satellite from PR 326 [\#333](https://github.com/voxpupuli/puppet-postfix/pull/333) ([cruelsmith](https://github.com/cruelsmith))
- Handle \[host\] vs \[host\]:port nexthop [\#327](https://github.com/voxpupuli/puppet-postfix/pull/327) ([gcoxmoz](https://github.com/gcoxmoz))

**Merged pull requests:**

- Update documentation and expected module usage behaviour [\#328](https://github.com/voxpupuli/puppet-postfix/pull/328) ([bkuebler](https://github.com/bkuebler))

## [v3.0.0](https://github.com/voxpupuli/puppet-postfix/tree/v3.0.0) (2022-05-05)

[Full Changelog](https://github.com/voxpupuli/puppet-postfix/compare/v2.0.0...v3.0.0)

**Breaking changes:**

- Drop support for FreeBSD 11 \(EOL\) [\#306](https://github.com/voxpupuli/puppet-postfix/pull/306) ([smortex](https://github.com/smortex))

**Implemented enhancements:**

- Declare CentOS 9 Support, Install s-nail on 9 [\#322](https://github.com/voxpupuli/puppet-postfix/pull/322) ([traylenator](https://github.com/traylenator))
- Add support for FreeBSD 13 [\#307](https://github.com/voxpupuli/puppet-postfix/pull/307) ([smortex](https://github.com/smortex))
- allow hiera driven transport/virtual/hash/conffile [\#296](https://github.com/voxpupuli/puppet-postfix/pull/296) ([cringdahl](https://github.com/cringdahl))

**Closed issues:**

- increase dependency of puppet/alternatives to next major version [\#324](https://github.com/voxpupuli/puppet-postfix/issues/324)
- smtp\_listen to take multiple addresses [\#203](https://github.com/voxpupuli/puppet-postfix/issues/203)

**Merged pull requests:**

- Add switches for simple domain masquerade [\#326](https://github.com/voxpupuli/puppet-postfix/pull/326) ([jcpunk](https://github.com/jcpunk))
- increase dependency of puppet/alternatives to next major version [\#325](https://github.com/voxpupuli/puppet-postfix/pull/325) ([KoenDierckx](https://github.com/KoenDierckx))
- Comply to rubocop 1.22.3 [\#321](https://github.com/voxpupuli/puppet-postfix/pull/321) ([traylenator](https://github.com/traylenator))
- remove unneeded tests; provide error message for raise\_error [\#318](https://github.com/voxpupuli/puppet-postfix/pull/318) ([kenyon](https://github.com/kenyon))
- map: handle regexp type [\#317](https://github.com/voxpupuli/puppet-postfix/pull/317) ([kenyon](https://github.com/kenyon))
- allow creation of postfix::map resources with hiera [\#316](https://github.com/voxpupuli/puppet-postfix/pull/316) ([kenyon](https://github.com/kenyon))
- init.pp: correct param numbers and use of optional [\#315](https://github.com/voxpupuli/puppet-postfix/pull/315) ([kenyon](https://github.com/kenyon))
- Allow parameter smtp\_listen to accept multiple IPs [\#313](https://github.com/voxpupuli/puppet-postfix/pull/313) ([ghost](https://github.com/ghost))
- Add manage\_mailname parameter  to README \(\#186\) [\#312](https://github.com/voxpupuli/puppet-postfix/pull/312) ([ghost](https://github.com/ghost))
- fixtures.yml: Migrate to git URLs [\#309](https://github.com/voxpupuli/puppet-postfix/pull/309) ([bastelfreak](https://github.com/bastelfreak))
- puppet-lint: fix top\_scope\_facts warnings [\#304](https://github.com/voxpupuli/puppet-postfix/pull/304) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/puppet-postfix/tree/v2.0.0) (2021-08-26)

[Full Changelog](https://github.com/voxpupuli/puppet-postfix/compare/1.12.0...v2.0.0)

**Breaking changes:**

- Drop RedHat 6; Add CentOS 7/8 support [\#301](https://github.com/voxpupuli/puppet-postfix/pull/301) ([root-expert](https://github.com/root-expert))
- Drop Fedora 28/29/30; Add Fedora 33/34 support [\#300](https://github.com/voxpupuli/puppet-postfix/pull/300) ([root-expert](https://github.com/root-expert))
- Drop puppet 4/5; Add Puppet 7 [\#299](https://github.com/voxpupuli/puppet-postfix/pull/299) ([root-expert](https://github.com/root-expert))
- Drop Debian 7/8/9; Add 10/11; Drop Ubuntu 14/16; Add 20.04 [\#298](https://github.com/voxpupuli/puppet-postfix/pull/298) ([root-expert](https://github.com/root-expert))

**Merged pull requests:**

- Allow stdlib 8.0.0 [\#302](https://github.com/voxpupuli/puppet-postfix/pull/302) ([smortex](https://github.com/smortex))

## [1.12.0](https://github.com/voxpupuli/puppet-postfix/tree/1.12.0) (2021-04-23)

[Full Changelog](https://github.com/voxpupuli/puppet-postfix/compare/1.11.0...1.12.0)

**Implemented enhancements:**

- puppetlabs/stdlib: Allow 7.x [\#294](https://github.com/voxpupuli/puppet-postfix/pull/294) ([bastelfreak](https://github.com/bastelfreak))
- Add FreeBSD support [\#288](https://github.com/voxpupuli/puppet-postfix/pull/288) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- master.cf.common.erb: fix smtp\_bind\_address typo [\#293](https://github.com/voxpupuli/puppet-postfix/pull/293) ([farlerac](https://github.com/farlerac))

## [1.11.0](https://github.com/voxpupuli/puppet-postfix/tree/1.11.0) (2021-01-20)

[Full Changelog](https://github.com/voxpupuli/puppet-postfix/compare/1.10.0...1.11.0)

**Implemented enhancements:**

- Add Solaris support [\#274](https://github.com/voxpupuli/puppet-postfix/pull/274) ([rstuart-indue](https://github.com/rstuart-indue))
- Feature/allow specify master cf content & template [\#217](https://github.com/voxpupuli/puppet-postfix/pull/217) ([c33s](https://github.com/c33s))
- Add a variable definition and two examples. [\#212](https://github.com/voxpupuli/puppet-postfix/pull/212) ([dafydd2277](https://github.com/dafydd2277))
-  Include parameter title in error output [\#209](https://github.com/voxpupuli/puppet-postfix/pull/209) ([mrintegrity](https://github.com/mrintegrity))
- more than two amavis processes [\#175](https://github.com/voxpupuli/puppet-postfix/pull/175) ([farlerac](https://github.com/farlerac))

**Closed issues:**

- Wrong tag on release 1.10.0 [\#276](https://github.com/voxpupuli/puppet-postfix/issues/276)
- Transport augeas test failed [\#241](https://github.com/voxpupuli/puppet-postfix/issues/241)

**Merged pull requests:**

- Fix CI [\#291](https://github.com/voxpupuli/puppet-postfix/pull/291) ([towo](https://github.com/towo))
- Fix CI [\#289](https://github.com/voxpupuli/puppet-postfix/pull/289) ([smortex](https://github.com/smortex))
- Fix hardcoded map path [\#287](https://github.com/voxpupuli/puppet-postfix/pull/287) ([towo](https://github.com/towo))
- Transport: allow \[host\]:port smtp syntax [\#285](https://github.com/voxpupuli/puppet-postfix/pull/285) ([raphink](https://github.com/raphink))
- README.md: fix link to puppet-lint [\#283](https://github.com/voxpupuli/puppet-postfix/pull/283) ([kenyon](https://github.com/kenyon))
- Fixes postmap when ensure=absent [\#202](https://github.com/voxpupuli/puppet-postfix/pull/202) ([earsdown](https://github.com/earsdown))
- Add virtual and transport regexp examples [\#116](https://github.com/voxpupuli/puppet-postfix/pull/116) ([micah](https://github.com/micah))

## [1.10.0](https://github.com/voxpupuli/puppet-postfix/tree/1.10.0) (2020-01-23)

[Full Changelog](https://github.com/voxpupuli/puppet-postfix/compare/1.9.0...1.10.0)

**Implemented enhancements:**

- Add the possibility to manage \(or not\) aliases [\#271](https://github.com/voxpupuli/puppet-postfix/pull/271) ([Bodenhaltung](https://github.com/Bodenhaltung))
- Convert to PDK [\#270](https://github.com/voxpupuli/puppet-postfix/pull/270) ([raphink](https://github.com/raphink))
- Convert params.pp to hiera data [\#269](https://github.com/voxpupuli/puppet-postfix/pull/269) ([raphink](https://github.com/raphink))

**Closed issues:**

- new release on forge [\#266](https://github.com/voxpupuli/puppet-postfix/issues/266)
- Add possibility to manage \(or not\) /etc/aliases [\#237](https://github.com/voxpupuli/puppet-postfix/issues/237)

**Merged pull requests:**

- Release 1.10.0 [\#273](https://github.com/voxpupuli/puppet-postfix/pull/273) ([raphink](https://github.com/raphink))
- Fix manage\_aliases [\#272](https://github.com/voxpupuli/puppet-postfix/pull/272) ([raphink](https://github.com/raphink))

## [1.9.0](https://github.com/voxpupuli/puppet-postfix/tree/1.9.0) (2019-11-26)

[Full Changelog](https://github.com/voxpupuli/puppet-postfix/compare/1.8.0...1.9.0)

**Implemented enhancements:**

- Upping version dependency on puppet-alternatives [\#260](https://github.com/voxpupuli/puppet-postfix/pull/260) ([cubiclelord](https://github.com/cubiclelord))
- Add RedHat 8 support [\#257](https://github.com/voxpupuli/puppet-postfix/pull/257) ([zeromind](https://github.com/zeromind))
- Add missing inet\_protocols parameter to the README. [\#254](https://github.com/voxpupuli/puppet-postfix/pull/254) ([catay](https://github.com/catay))
- add retry and proxywrite for debian family OSes [\#253](https://github.com/voxpupuli/puppet-postfix/pull/253) ([Dan33l](https://github.com/Dan33l))
- Allow `puppetlabs/stdlib` 6.x [\#246](https://github.com/voxpupuli/puppet-postfix/pull/246) ([alexjfisher](https://github.com/alexjfisher))
- Add show\_diff parameter to postfix::conffile [\#226](https://github.com/voxpupuli/puppet-postfix/pull/226) ([treydock](https://github.com/treydock))

**Fixed bugs:**

- Should mailalias\_core be declared as a dependency ? [\#236](https://github.com/voxpupuli/puppet-postfix/issues/236)

**Closed issues:**

- Add Debian Stretch to metadata.json [\#259](https://github.com/voxpupuli/puppet-postfix/issues/259)
- qmgr warning: connect to transport private/retry [\#252](https://github.com/voxpupuli/puppet-postfix/issues/252)
- Clarify license [\#250](https://github.com/voxpupuli/puppet-postfix/issues/250)

**Merged pull requests:**

- Release 1.9.0 [\#265](https://github.com/voxpupuli/puppet-postfix/pull/265) ([alexjfisher](https://github.com/alexjfisher))
- Add missing Variable for Suse [\#245](https://github.com/voxpupuli/puppet-postfix/pull/245) ([cocker-cc](https://github.com/cocker-cc))

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
