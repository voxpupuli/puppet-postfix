#
#== Definition: postfix::mailalias
#
#Wrapper around Puppet mailalias resource, provides newaliases executable.
#
#Parameters:
#- *name*: the name of the alias.
#- *ensure*: present/absent, defaults to present.
#- *recipient*: recipient of the alias.
#
#Requires:
#- Class["postfix"]
#
#Example usage:
#
#  node "toto.example.com" {
#
#    include postfix
#
#    postfix::mailalias { "postmaster":
#      ensure    => present,
#      recipient => 'foo'
#  }
#
#*/
define postfix::mailalias ($ensure = 'present', $recipient) {
    mailalias { $name:
        recipient => $recipient,
        ensure    => $ensure,
        notify    => Exec['newaliases'],
    }
}
