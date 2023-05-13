# @summary Provides augeas lenses for postfix files
#
# This class provides the augeas lenses used by the postfix class
#
# @api private
#
class postfix::augeas {
  assert_private()

  $module_path = get_module_path($module_name)
  augeas::lens { 'postfix_canonical':
    ensure       => present,
    lens_content => file("${module_path}/files/lenses/postfix_canonical.aug"),
    test_content => file("${module_path}/files/lenses/test_postfix_canonical.aug"),
  }
}
