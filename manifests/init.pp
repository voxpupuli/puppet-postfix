#
# == Class: postfix
#
# This class provides a basic setup of postfix with local and remote
# delivery and an SMTP server listening on the loopback interface.
#
# Parameters:
# [*inet_interfaces*]     - (string)
#
# [*mail_user*]           - (string) The mail user
#
# [*mailman*]             - (boolean)
#
# [*master_smtp*]         - (string)
#
# [*master_smtps*]        - (string)
#
# [*master_submission*]   - (string)
#
# [*mta*]                 - (boolean)
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
# [*satellite*]           - (boolean)
#
# [*smtp_listen*]         - (string)
#
# [*use_amavisd*]         - (boolean)
#
# [*use_dovecot_lda*]     - (boolean)
#
# [*use_schleuder*]       - (boolean)
#
# [*use_sympa*]           - (boolean)
#
# Example usage:
#
#   node 'toto.example.com' {
#     $postfix_smtp_listen = '192.168.1.10'
#     include postfix
#   }
#
class postfix (
  $inet_interfaces     = 'all',
  $mail_user           = 'vmail',     # postfix_mail_user
  $mailman             = false,
  $maincf_source       = "puppet:///modules/${module_name}/main.cf",
  $mastercf_source     = undef,
  $master_smtp         = undef,       # postfix_master_smtp
  $master_smtps        = undef,       # postfix_master_smtps
  $master_submission   = undef,       # postfix_master_submission
  $mta                 = false,
  $mydestination       = undef,       # postfix_mydestination
  $mynetworks          = undef,       # postfix_mynetworks
  $myorigin            = $::fqdn,
  $relayhost           = undef,       # postfix_relayhost
  $root_mail_recipient = 'nobody',    # root_mail_recipient
  $satellite           = false,
  $smtp_listen         = '127.0.0.1', # postfix_smtp_listen
  $use_amavisd         = false,       # postfix_use_amavisd
  $use_dovecot_lda     = false,       # postfix_use_dovecot_lda
  $use_schleuder       = false,       # postfix_use_schleuder
  $use_sympa           = false,       # postfix_use_sympa
) inherits postfix::params {


  validate_bool($mailman)
  validate_bool($mta)
  validate_bool($satellite)
  validate_bool($use_amavisd)
  validate_bool($use_dovecot_lda)
  validate_bool($use_schleuder)
  validate_bool($use_sympa)

  validate_string($inet_interfaces)
  validate_string($mail_user)
  validate_string($master_smtp)
  validate_string($master_smtps)
  validate_string($mydestination)
  validate_string($mynetworks)
  validate_string($myorigin)
  validate_string($relayhost)
  validate_string($root_mail_recipient)
  validate_string($smtp_listen)



  $_smtp_listen = $mailman ? {
    true    => '0.0.0.0',
    default => $smtp_listen,
  }

  class { 'postfix::packages': } ->
  class { 'postfix::files': } ~>
  class { 'postfix::service': } ->
  Class['postfix']

  if $mta {
    include ::postfix::mta
  }

  if $satellite {
    include ::postfix::satellite
  }

  if $mailman {
    include ::postfix::mailman
  }
}
