#
# == Class: postfix
#
# This class provides a basic setup of postfix with local and remote
# delivery and an SMTP server listening on the loopback interface.
#
# Parameters:
# - *$postfix_smtp_listen*: address on which the smtp service will listen to. defaults to 127.0.0.1
# - *$root_mail_recipient*: who will recieve root's emails. defaults to "nobody"
#
# Example usage:
#
#   node "toto.example.com" {
#     $postfix_smtp_listen = "192.168.1.10"
#     include postfix
#   }
#
class postfix {

  # selinux labels differ from one distribution to another
  case $operatingsystem {

    RedHat, CentOS: {
      case $lsbmajdistrelease {
        "4":     { $postfix_seltype = "etc_t" }
        "5","6": { $postfix_seltype = "postfix_etc_t" }
        default: { $postfix_seltype = undef }
      }
    }

    default: {
      $postfix_seltype = undef
    }
  }

  # Default value for various options
  case $postfix_smtp_listen {
    "": { $postfix_smtp_listen = "127.0.0.1" }
  }
  case $root_mail_recipient {
    "":   { $root_mail_recipient = "nobody" }
  }
  case $postfix_use_amavisd {
    "": { $postfix_use_amavisd = "no" }
  }
  case $postfix_use_dovecot_lda {
    "": { $postfix_use_dovecot_lda = "no" }
  }
  case $postfix_use_schleuder {
    "": { $postfix_use_schleuder = "no" }
  }
  case $postfix_use_sympa {
    "": { $postfix_use_sympa = "no" }
  }
  case $postfix_mail_user {
    "": { $postfix_mail_user = "vmail" }
  }


  package { "postfix":
    ensure => installed
  }

  package { "mailx":
    ensure => installed,
    name   => $lsbdistcodename ? {
      "squeeze" => "bsd-mailx",
      "lucid"   => "bsd-mailx",
      default   => "mailx",
    },
  }

  service { "postfix":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    restart   => "/etc/init.d/postfix reload",
    require   => Package["postfix"],
  }

  file { "/etc/mailname":
    ensure  => present,
    content => "${fqdn}\n",
    seltype => $postfix_seltype,
  }

  # Aliases
  file { "/etc/aliases":
    ensure => present,
    content => "# file managed by puppet\n",
    replace => false,
    seltype => $postfix_seltype,
    notify => Exec["newaliases"],
  }

  # Aliases
  exec { "newaliases":
    command     => "/usr/bin/newaliases",
    refreshonly => true,
    require     => Package["postfix"],
    subscribe   => File["/etc/aliases"],
  }

  # Config files
  file { "/etc/postfix/master.cf":
    ensure  => present,
    owner => "root",
    group => "root",
    mode => "0644",
    content => $operatingsystem ? {
      /RedHat|CentOS/ => template("postfix/master.cf.redhat.erb", "postfix/master.cf.common.erb"),
      /Debian|Ubuntu|kFreeBSD/ => template("postfix/master.cf.debian.erb", "postfix/master.cf.common.erb"),
    },
    seltype => $postfix_seltype,
    notify  => Service["postfix"],
    require => Package["postfix"],
  }

  # Config files
  file { "/etc/postfix/main.cf":
    ensure  => present,
    owner => "root",
    group => "root",
    mode => "0644",
    source  => "puppet:///modules/postfix/main.cf",
    replace => false,
    seltype => $postfix_seltype,
    notify  => Service["postfix"],
    require => Package["postfix"],
  }

  # Default configuration parameters
  postfix::config {
    "myorigin":   value => "${fqdn}";
    "alias_maps": value => "hash:/etc/aliases";
    "inet_interfaces": value => "all";
  }

  case $operatingsystem {
    RedHat, CentOS: {
      postfix::config {
        "sendmail_path": value => "/usr/sbin/sendmail.postfix";
        "newaliases_path": value => "/usr/bin/newaliases.postfix";
        "mailq_path": value => "/usr/bin/mailq.postfix";
      }
    }
  }

  mailalias {"root":
    recipient => $root_mail_recipient,
    notify    => Exec["newaliases"],
  }
}
