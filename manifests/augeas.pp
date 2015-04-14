#class postfix::augeas
#  This class provides the augeas lenses used by the postfix class
#
class postfix::augeas {

  if versioncmp(inline_template('<%= Puppet.version %>'), '3.7') < 0 {
    $module_path = get_module_path('postfix')
    $postfix_transport_lens_content = file("${module_path}/files/lenses/postfix_transport.aug")
    $postfix_transport_test_content = file("${module_path}/files/lenses/test_postfix_transport.aug")
    $postfix_virtual_lens_content   = file("${module_path}/files/lenses/postfix_virtual.aug")
    $postfix_virtual_test_content   = file("${module_path}/files/lenses/test_postfix_virtual.aug")
    $postfix_canonical_lens_content = file("${module_path}/files/lenses/postfix_canonical.aug")
    $postfix_canonical_test_content = file("${module_path}/files/lenses/test_postfix_canonical.aug")
  } else {
    $postfix_transport_lens_content = file('postfix/lenses/postfix_transport.aug')
    $postfix_transport_test_content = file('postfix/lenses/test_postfix_transport.aug')
    $postfix_virtual_lens_content   = file('postfix/lenses/postfix_virtual.aug')
    $postfix_virtual_test_content   = file('postfix/lenses/test_postfix_virtual.aug')
    $postfix_canonical_lens_content = file('postfix/lenses/postfix_canonical.aug')
    $postfix_canonical_test_content = file('postfix/lenses/test_postfix_canonical.aug')
  }

  augeas::lens {'postfix_transport':
    ensure       => present,
    lens_content => $postfix_transport_lens_content,
    test_content => $postfix_transport_test_content,
    stock_since  => '1.0.0',
  }
  augeas::lens {'postfix_virtual':
    ensure       => present,
    lens_content => $postfix_virtual_lens_content,
    test_content => $postfix_virtual_test_content,
    stock_since  => '1.0.0',
  }
  augeas::lens {'postfix_canonical':
    ensure       => present,
    lens_content => $postfix_canonical_lens_content,
    test_content => $postfix_canonical_test_content,
  }
}
