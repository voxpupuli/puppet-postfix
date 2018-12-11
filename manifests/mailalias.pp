# == Definition: postfix::mailalias
#
# Creates an email alias in the local alias database and updates the binary
# version of said database.
#
# === Parameters
#
# [*name*]      - the alias name. See aliases(5).
# [*ensure*]    - present/absent, defaults to present.
# [*recipient*] - where email should be sent.
#
# === Requires
#
# - Class["postfix"]
#
# === Examples
#
#   node "toto.example.com" {
#
#     include postfix
#
#     postfix::mailalias { 'postmaster':
#       ensure    => present,
#       recipient => 'foo',
#     }
#
define postfix::mailalias (
  Variant[String, Array[String]] $recipient,
  Enum['present', 'absent']      $ensure='present',
) {
  mailalias { $title:
    ensure    => $ensure,
    name      => $name,
    recipient => $recipient,
    notify    => Exec['newaliases'],
  }
}
