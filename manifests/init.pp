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
  $use_amavisd = 'no',                # postfix_use_amavisd
  $use_dovecot_lda = 'no',            # postfix_use_dovecot_lda
  $use_schleuder = 'no',              # postfix_use_schleuder
  $use_sympa = 'no',                  # postfix_use_sympa
  $mail_user = 'vmail',               # postfix_mail_user
  $myorigin = $::fqdn,
  $inet_interfaces = 'localhost',
) inherits postfix::params {

  class { 'postfix::packages': } ->
  class { 'postfix::files': } ~>
  class { 'postfix::service': } ->
  Class['postfix']
}
