# @summary Configure Postfix as satellite
#
# @api private
#
class postfix::satellite (
  $mydestination = undef,
  $mynetworks    = undef,
  $relayhost     = undef,
  $masquerade_classes    = undef,
  $masquerade_domains    = undef,
  $masquerade_exceptions = undef,
) {
  assert_private()
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
    masquerade_classes    => $masquerade_classes,
    masquerade_domains    => $masquerade_domains,
    masquerade_exceptions => $masquerade_exceptions,
  }

  postfix::virtual { "@${postfix::myorigin}":
    ensure      => 'present',
    destination => 'root',
  }
}
