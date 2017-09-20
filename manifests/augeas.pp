#class postfix::augeas
#  This class provides the augeas lenses used by the postfix class
#
class postfix::augeas {

  $module_path = get_module_path($module_name)
  augeas::lens {'postfix_transport':
    ensure       => present,
    lens_content => file("${module_path}/files/lenses/postfix_transport.aug"),
    test_content => file("${module_path}/files/lenses/test_postfix_transport.aug"),
    stock_since  => '1.0.0',
  }
  augeas::lens {'postfix_virtual':
    ensure       => present,
    lens_content => file("${module_path}/files/lenses/postfix_virtual.aug"),
    test_content => file("${module_path}/files/lenses/test_postfix_virtual.aug"),
    stock_since  => '1.7.0',
  }
  augeas::lens {'postfix_canonical':
    ensure       => present,
    lens_content => file("${module_path}/files/lenses/postfix_canonical.aug"),
    test_content => file("${module_path}/files/lenses/test_postfix_canonical.aug"),
  }
}
