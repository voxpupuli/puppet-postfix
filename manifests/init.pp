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
) inherits postfix::params {

  validate_bool($use_amavisd)
  validate_bool($use_dovecot_lda)
  validate_bool($use_schleuder)
  validate_bool($use_sympa)
  validate_string($mail_user)
  validate_string($myorigin)
  validate_string($inet_interfaces)
  validate_string($master_smtp)
  validate_string($master_smtps)

  class { 'postfix::packages': } ->
  class { 'postfix::files':
    use_amavisd       => $use_amavisd,
    use_dovecot_lda   => $use_dovecot_lda,
    use_schleuder     => $use_schleuder,
    use_sympa         => $use_sympa,
    smtp_listen       => $smtp_listen,
    mail_user         => $mail_user,
    master_smtp       => $master_smtp,
    master_smtps      => $master_smtps,
    master_submission => $master_submission,
    } ~>
  class { 'postfix::service': } ->
  Class['postfix']
}
