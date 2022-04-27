# @summary Manage the content of the Postfix alias map
#
# Creates an email alias in the local alias database and updates the binary
# version of said database.
#
# @example Simple example
#   include postfix
#   postfix::mailalias { 'postmaster':
#     ensure    => present,
#     recipient => 'foo',
#   }
#
# @param ensure
#   Intended state of the resource
#
# @param recipient
#   The recipient address where the mail should be sent to.
#
# @see http://www.postfix.org/aliases.5.html
#
define postfix::mailalias (
  Variant[String, Array[String]] $recipient,
  Enum['present', 'absent']      $ensure    = 'present'
) {
  mailalias { $title:
    ensure    => $ensure,
    name      => $name,
    recipient => $recipient,
    notify    => Exec['newaliases'],
  }
}
