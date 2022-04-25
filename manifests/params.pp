# @summary Default parameters
#
# This class provides the appropriate values for operating system specific variables.
#
# @param mailx_package
#   Name of package that provides mailx
#
# @param restart_cmd
#   Command to use when restarting postfix
#
# @param aliasesseltype
#   Selinux type for /etc/aliases
#
# @param seltype
#   Selinux type for /etc/postfix/* config files
#
# @param master_os_template
#   Path to the master template
#
# @api private
#
class postfix::params (
  String $mailx_package,
  String $restart_cmd,
  String $master_os_template,
  Optional[String] $aliasesseltype,
  Optional[String] $seltype,
) {
}
