#
# == Class: postfix
#
# This class provides a basic setup of postfix with local and remote
# delivery and an SMTP server listening on the loopback interface.
#
# Parameters:
# - *$postfix_smtp_listen*: address on which the smtp service will listen to.
#      defaults to 127.0.0.1
# - *$root_mail_recipient*: who will recieve root's emails. defaults to 'nobody'
#
# Example usage:
#
#   node 'toto.example.com' {
#     $postfix_smtp_listen = '192.168.1.10'
#     include postfix
#   }
#
class postfix (
  $smtp_listen = '127.0.0.1',         # postfix_smtp_listen
  $root_mail_recipient = 'nobody',    # root_mail_recipient
  $use_amavisd = false,               # postfix_use_amavisd
  $use_dovecot_lda = false,           # postfix_use_dovecot_lda
  $use_schleuder = false,             # postfix_use_schleuder
  $use_sympa = false,                 # postfix_use_sympa
  $mail_user = 'vmail',               # postfix_mail_user
  $myorigin = $::fqdn,
  $inet_interfaces = 'localhost',
  $master_smtp = undef,               # postfix_master_smtp
  $master_smtps = undef,              # postfix_master_smtps
  $master_submission = undef,         # postfix_master_submission
  $relayhost = undef,                 # postfix_relayhost
  $mydestination = undef,             # postfix_mydestination
  $mynetworks = undef,                # postfix_mynetworks
  $mta = false,
  $satellite = false,
  $mailman = false,
) inherits postfix::params {

  validate_string($smtp_listen)
  validate_string($root_mail_recipient)
  validate_bool($use_amavisd)
  validate_bool($use_dovecot_lda)
  validate_bool($use_schleuder)
  validate_bool($use_sympa)
  validate_string($mail_user)
  validate_string($myorigin)
  validate_string($inet_interfaces)
  validate_string($master_smtp)
  validate_string($master_smtps)
  validate_string($relayhost)
  validate_string($mydestination)
  validate_string($mynetworks)

  validate_bool($mta)
  validate_bool($satellite)
  validate_bool($mailman)

  $_smtp_listen = $mailman ? {
    true    => '0.0.0.0',
    default => $smtp_listen,
  }

  class { 'postfix::packages': } ->
  class { 'postfix::files':
    smtp_listen         => $_smtp_listen,
    root_mail_recipient => $root_mail_recipient,
    use_amavisd         => $use_amavisd,
    use_dovecot_lda     => $use_dovecot_lda,
    use_schleuder       => $use_schleuder,
    use_sympa           => $use_sympa,
    mail_user           => $mail_user,
    myorigin            => $myorigin,
    inet_interfaces     => $inet_interfaces,
    master_smtp         => $master_smtp,
    master_smtps        => $master_smtps,
    master_submission   => $master_submission,
    } ~>
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
