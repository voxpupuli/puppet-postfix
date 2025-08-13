# @summary Configure Postfix as satellite
#
# @api private
#
class postfix::satellite (
  Optional[String]           $mydestination         = undef,
  Optional[String]           $mynetworks            = undef,
  Optional[String]           $relayhost             = undef,
  Optional[Array[String[1]]] $masquerade_classes    = undef,
  Optional[Array[String[1]]] $masquerade_domains    = undef,
  Optional[Array[String[1]]] $masquerade_exceptions = undef,
) {
  assert_private()
  include postfix

  assert_type(Pattern[/^\S+$/], $postfix::myorigin)

  $_mydestination = pick($mydestination, $postfix::mydestination)
  $_mynetworks = pick($mynetworks, $postfix::mynetworks)
  $_relayhost = pick($relayhost, $postfix::relayhost)
  $_masquerade_classes    = $masquerade_classes.lest || { $postfix::masquerade_classes }
  $_masquerade_domains    = $masquerade_domains.lest || { $postfix::masquerade_domains }
  $_masquerade_exceptions = $masquerade_exceptions.lest || { $postfix::masquerade_exceptions }

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
