class postfix::augeas {
  augeas::lens {'postfix_transport':
    ensure      => present,
    lens_source => "puppet:///modules/${module_name}/lenses/postfix_transport.aug",
    test_source => "puppet:///modules/${module_name}/lenses/test_postfix_transport.aug",
    stock_since => '1.0.0',
  }
  augeas::lens {'postfix_virtual':
    ensure      => present,
    lens_source => "puppet:///modules/${module_name}/lenses/postfix_virtual.aug",
    test_source => "puppet:///modules/${module_name}/lenses/test_postfix_virtual.aug",
    stock_since => '1.0.0',
  }
}
