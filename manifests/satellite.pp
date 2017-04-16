#
# == Class: postfix::satellite
#
# This class configures all local email (cron, mdadm, etc) to be forwarded
# to $root_mail_recipient, using $relayhost as a relay.
#
# This class will call postfix::mta and override its parameters.
# You shouldn't call postfix::mta yourself or use mta=true in the postfix class.
#
# === Parameters
#
# [*mydestination*] - (string)
# [*mynetworks*] - (string)
# [*relayhost*] - (string)
#
# === Examples
#
#   class { 'postfix':
#     relayhost           => 'mail.example.com',
#     myorigin            => 'toto.example.com',
#     root_mail_recipient => 'the.sysadmin@example.com',
#     satellite           => true,
#   }
#
class postfix::satellite (
  $mydestination = $postfix::mydestination,
  $mynetworks    = $postfix::mynetworks,
  $relayhost     = $postfix::relayhost,
  $smtp_use_tls  = $postfix::smtp_use_tls
) {

  validate_re($postfix::myorigin, '^\S+$')
  validate_re($smtp_use_tls, '^\S+$',
              'Wrong value for $smtp_use_tls')

  class { '::postfix::mta':
    mydestination => $mydestination,
    mynetworks    => $mynetworks,
    relayhost     => $relayhost,
    smtp_use_tls  => $smtp_use_tls
  }

  postfix::virtual { "@${postfix::myorigin}":
    ensure      => 'present',
    destination => 'root',
  }
}
