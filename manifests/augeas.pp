#class postfix::augeas
#  This class provides the augeas lenses used by the postfix class
#
class postfix::augeas {
  augeas::lens {'postfix_transport':
    ensure       => present,
    lens_content => template('postfix/lenses/postfix_transport.aug'),
    test_content => template('postfix/lenses/test_postfix_transport.aug'),
    stock_since  => '1.0.0',
  }
  augeas::lens {'postfix_virtual':
    ensure       => present,
    lens_content => template('postfix/postfix_virtual.aug'),
    test_content => template('postfix/test_postfix_virtual.aug'),
    stock_since  => '1.0.0',
  }
  augeas::lens {'postfix_canonical':
    ensure       => present,
    lens_content => template('postfix/postfix_canonical.aug'),
    test_content => template('postfix/test_postfix_canonical.aug'),
  }
}
