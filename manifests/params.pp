#
# == Class: postfix::params
#
# This class provides the appropriate values for operating system specific variables.
#
# === Parameters
#
# [*mailx_package*]  - (string) Name of package that provides mailx
#
# [*restart_cmd*]    - (hash) Command to use when restarting postfix
#
# [*aliasesseltype*] - (string) Selinux type for /etc/aliases
#
# [*seltype*]        - (string) Selinux type for /etc/postfix/* config files
#
class postfix::params (
  String $mailx_package,
  String $restart_cmd,
  Optional[String] $aliasesseltype,
  Optional[String] $seltype,
) {
}
