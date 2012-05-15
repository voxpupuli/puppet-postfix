class postfix::params {

  case $::operatingsystem {
    RedHat, CentOS: {
      case $::lsbmajdistrelease {
        '4':     { $seltype = 'etc_t' }
        '5','6': { $seltype = 'postfix_etc_t' }
        default: { $seltype = undef }
      }
    }

    default: {
      $seltype = undef
    }
  }

  $myorigin = $postfix_myorigin ? {
    ''      => $::fqdn,
    default => $postfix_myorigin,
  }
}
