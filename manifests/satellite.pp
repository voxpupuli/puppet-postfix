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
  $mydestination = undef,
  $mynetworks    = undef,
  $relayhost     = undef,
) {
  include postfix

  assert_type(Pattern[/^\S+$/], $postfix::myorigin)

  $_mydestination = pick($mydestination, $postfix::mydestination)
  $_mynetworks = pick($mynetworks, $postfix::mynetworks)
  $_relayhost = pick($relayhost, $postfix::relayhost)

  class { '::postfix::mta':
    mydestination => $_mydestination,
    mynetworks    => $_mynetworks,
    relayhost     => $_relayhost,
  }

  postfix::virtual { "@${postfix::myorigin}":
    ensure      => 'present',
    destination => 'root',
  }
}
