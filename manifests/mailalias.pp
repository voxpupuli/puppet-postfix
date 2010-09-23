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
define postfix::mailalias ($recipient, $ensure = 'present') {
    mailalias { $name:
        ensure    => $ensure,
        recipient => $recipient,
        notify    => Exec['newaliases'],
    }
}
