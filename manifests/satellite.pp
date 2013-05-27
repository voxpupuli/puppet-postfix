#
# == Class: postfix::satellite
#
# This class configures all local email (cron, mdadm, etc) to be forwarded
# to $root_mail_recipient, using $postfix_relayhost as a relay.
#
# $valid_fqdn can be set to override $fqdn in the case where the FQDN is
# not recognized as valid by the destination server.
#
# Parameters:
# - *valid_fqdn*
# - every global variable which works for class 'postfix' will work here.
#
# Example usage:
#
#   node 'toto.local.lan' {
#     $postfix_relayhost = 'mail.example.com'
#     $valid_fqdn = 'toto.example.com'
#     $root_mail_recipient = 'the.sysadmin@example.com'
#
#     include postfix::satellite
#   }
#
class postfix::satellite {

  validate_re($postfix::myorigin, '^\S+$')

  include ::postfix::mta

  postfix::virtual { "@${postfix::myorigin}":
    ensure      => present,
    destination => 'root',
  }
}
