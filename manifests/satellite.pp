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
# [*masquerade_classes*]    - (array)
# [*masquerade_domains*]    - (array)
# [*masquerade_exceptions*] - (array)
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
  $masquerade_classes    = undef,
  $masquerade_domains    = undef,
  $masquerade_exceptions = undef,
) {
  include postfix

  assert_type(Pattern[/^\S+$/], $postfix::myorigin)

  $_mydestination = pick($mydestination, $postfix::mydestination)
  $_mynetworks = pick($mynetworks, $postfix::mynetworks)
  $_relayhost = pick($relayhost, $postfix::relayhost)
  $_masquerade_classes    = pick_default($masquerade_classes, $postfix::masquerade_classes)
  $_masquerade_domains    = pick_default($masquerade_domains, $postfix::masquerade_domains)
  $_masquerade_exceptions = pick_default($masquerade_exceptions, $postfix::masquerade_exceptions)

  class { 'postfix::mta':
    mydestination         => $_mydestination,
    mynetworks            => $_mynetworks,
    relayhost             => $_relayhost,
    masquerade_classes    => $_masquerade_classes,
    masquerade_domains    => $_masquerade_domains,
    masquerade_exceptions => $_masquerade_exceptions,
  }

  postfix::virtual { "@${postfix::myorigin}":
    ensure      => 'present',
    destination => 'root',
  }
}
