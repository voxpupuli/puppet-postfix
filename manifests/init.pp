#
# == Class: postfix
#
# This class provides a basic setup of postfix with local and remote
# delivery and an SMTP server listening on the loopback interface.
#
# === Parameters
#
# [*alias_maps*]          - (string)
#
# [*inet_interfaces*]     - (string)
#
# [*ldap*]                - (boolean) Whether to use LDAP
#
# [*ldap_base*]           - (string)
#
# [*ldap_host*]           - (string)
#
# [*ldap_options*]        - (string)
#
# [*mail_user*]           - (string) The mail user
#
# [*mailman*]             - (boolean)
#
# [*maincf_source*]       - (string)
#
# [*manage_conffiles*]    - (boolean) Whether config files are to be replaced
#
# [*mastercf_source*]     - (string)
#
# [*master_smtp*]         - (string)
#
# [*master_smtps*]        - (string)
#
# [*master_submission*]   - (string)
#
# [*mta*]                 - (boolean) Configure postfix minimally, as a simple MTA
#
# [*mydestination*]       - (string)
#
# [*mynetworks*]          - (string)
#
# [*myorigin*]            - (string)
#
# [*relayhost*]           - (string)
#
# [*root_mail_recipient*] - (string)
#
# [*satellite*]           - (boolean) Whether to use as a satellite
#                           (implies MTA)
#
# [*smtp_listen*]         - (string) The SMTP listen interface
#
# [*use_amavisd*]         - (boolean) Whether to setup for Amavis
#
# [*use_dovecot_lda*]     - (boolean) Whether to setup for Dovecot LDA
#
# [*use_schleuder*]       - (boolean) Whether to setup for Schleuder
#
# [*use_sympa*]           - (boolean) Whether to setup for Sympa
#
# [*postfix_ensure*]      - (string) The ensure value of the postfix package
#
# [*mailx_ensure*]        - (string) The ensure value of the mailx package
#
# === Examples
#
#   class { 'postfix':
#     smtp_listen => '192.168.1.10',
#   }
#
class postfix (
  $alias_maps          = 'hash:/etc/aliases',
  $inet_interfaces     = 'all',
  $ldap                = false,
  $ldap_base           = undef,
  $ldap_host           = undef,
  $ldap_options        = undef,
  $mail_user           = 'vmail',       # postfix_mail_user
  $mailman             = false,
  $maincf_source       = "puppet:///modules/${module_name}/main.cf",
  $manage_conffiles    = true,
  $mastercf_source     = undef,
  $master_smtp         = undef,         # postfix_master_smtp
  $master_smtps        = undef,         # postfix_master_smtps
  $master_submission   = undef,         # postfix_master_submission
  $mta                 = false,
  $mydestination       = '$myorigin',   # postfix_mydestination
  $mynetworks          = '127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128', # postfix_mynetworks
  $myorigin            = $::fqdn,
  $relayhost           = undef,         # postfix_relayhost
  $manage_root_alias   = true,
  $root_mail_recipient = 'nobody',      # root_mail_recipient
  $satellite           = false,
  $smtp_listen         = '127.0.0.1',   # postfix_smtp_listen
  $use_amavisd         = false,         # postfix_use_amavisd
  $use_dovecot_lda     = false,         # postfix_use_dovecot_lda
  $use_schleuder       = false,         # postfix_use_schleuder
  $use_sympa           = false,         # postfix_use_sympa
  $postfix_ensure      = 'present',
  $mailx_ensure        = 'present',
) inherits postfix::params {


  validate_bool($ldap)
  validate_bool($mailman)
  validate_bool($mta)
  validate_bool($manage_root_alias)
  validate_bool($satellite)
  validate_bool($use_amavisd)
  validate_bool($use_dovecot_lda)
  validate_bool($use_schleuder)
  validate_bool($use_sympa)

  validate_string($alias_maps)
  validate_string($inet_interfaces)
  validate_string($ldap_base)
  validate_string($ldap_host)
  validate_string($ldap_options)
  validate_string($mail_user)
  validate_string($maincf_source)
  validate_string($mastercf_source)
  validate_string($master_smtp)
  validate_string($master_smtps)
  validate_string($mydestination)
  validate_string($mynetworks)
  validate_string($myorigin)
  validate_string($relayhost)
  if ! is_array($root_mail_recipient) {
    validate_string($root_mail_recipient)
  }
  validate_string($smtp_listen)



  $_smtp_listen = $mailman ? {
    true    => '0.0.0.0',
    default => $smtp_listen,
  }

  $all_alias_maps = $ldap ? {
    false => $alias_maps,
    true  => "${alias_maps}, ldap:/etc/postfix/ldap-aliases.cf",
  }

  anchor { 'postfix::begin': } ->
  class { '::postfix::packages': } ->
  class { '::postfix::files': } ~>
  class { '::postfix::service': } ->
  anchor { 'posfix::end': }

  if $ldap {
    include ::postfix::ldap
  }

  if $mta {
    if $satellite {
      fail('enabling both the $mta and $satellite parameters is not supported. Please disable one.')
    }
    include ::postfix::mta
  }

  if $satellite {
    if $mta {
      fail('enabling both the $mta and $satellite parameters is not supported. Please disable one.')
    }
    include ::postfix::satellite
  }

  if $mailman {
    include ::postfix::mailman
  }
}
