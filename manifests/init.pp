# @summary The top-level class, to install and configure Postfix
#
# This class provides a basic setup of Postfix with local and remote
# delivery and an SMTP server listening on the loopback interface.
#
# @example Default Postfix with listen address
#   class { 'postfix':
#     smtp_listen => '192.168.1.10',
#   }
#
# @example Minimal MTA setup
#   # This class configures a minimal MTA, delivering mail to
#   # $mydestination. Either a valid relay host or the special
#   # word 'direct' is required ($relayhost) for outbound email.
#   #
#   # transport & virtual maps get configured and can be populated with
#   # postfix::transport and postfix::virtual
#   #
#   class { 'postfix':
#     relayhost     => 'mail.example.com',
#     smtp_listen   => '0.0.0.0',
#     mydestination => '$myorigin, myapp.example.com',
#     mta           => true,
#   }
#
# @example Configure Postfix as satellite
#   # This configures all local email (cron, mdadm, etc) to be forwarded
#   # to $root_mail_recipient, using $relayhost as a relay.
#   #
#   # This will call postfix::mta and override its parameters.
#   # You shouldn't call postfix::mta yourself or use mta=true in the postfix class.
#   class { 'postfix':
#     relayhost           => 'mail.example.com',
#     myorigin            => 'toto.example.com',
#     root_mail_recipient => 'the.sysadmin@example.com',
#     satellite           => true,
#   }
#
# @param alias_maps
#   A string defining the location of the alias map file.
#   Example: `hash:/etc/other_aliases`
#
# @param amavis_procs
#   Number of amavis scanner processes to spawn
#
# @param chroot
#   A boolean to define if Postfix should be run in a chroot jail or not.
#   If not defined, '-' is used (OS dependant)
#   Example: `true`
#
# @param confdir
#   The base path which should be used as confdir
#
# @param conffiles
#   A hash of postfix::conffile resources
#
# @param configs
#   A hash of postfix::config resources. The hash containing optional configuration values for main.cf.
#   The values are configured using postfix::config.
#   Example: `{'message_size_limit': {'value': '51200000'}}`
#
# @param hashes
#   A hash of postfix::hash resources
#
# @param inet_interfaces
#   A string defining the network interfaces that Postfix will listen on.
#   Example: `127.0.0.1, [::1]`
#
# @param inet_protocols
#   A string defining the internet protocols that Postfix will use.
#   Example: `ipv4`
#
# @param ldap
#   A Boolean defining whether to configure Postfix for LDAP use.
#
# @param ldap_base
#   A string defining the LDAP search base to use. This parameter maps to the
#   search_base parameter (ldap_table(5)).
#   Example: `cn=Users,dc=example,dc=com`
#
# @param ldap_host
#   A string defining the LDAP host. This parameter maps to the server_host parameter (ldap_table(5)).
#   Example: `ldaps://ldap.example.com:636 ldap://ldap2.example.com`.
#
# @param ldap_options
#   A free form string that can define any LDAP options to be passed through (ldap_table(5)).
#   Example: `start_tls = yes`.
#
# @param ldap_packages
#   An array of package names to install for LDAP support if $ldap is true.
#
# @param lookup_table_type
#   Table format type as described in http://www.postfix.org/DATABASE_README.html#types.
#   Type has to be supported by system, see "postconf -m" for supported types.
#
# @param mailaliases
#   A hash of postfix::mailalias resources. The hash containing optional configuration values for main.cf.
#   The values are configured using postfix::mailalias.
#   Example: `{'nobody': {'ensure': 'present', 'recipient': 'root'}}`
#
# @param mail_user
#   A string defining the mail user, and optionally group, to execute external commands as.
#   This parameter maps to the user parameter (pipe(8)).
#   Example: `vmail:vmail`.
#
# @param mailman
#   A Boolean defining whether to configure a basic smtp server that is able to work for the
#   mailman mailing list manager.
#
# @param mailx_ensure
#   Installs mailx package
#
# @param maincf_source
#   A string defining the location of a skeleton main.cf file to be used. The default file
#   supplied is blank. However, if the main.cf file already exists on the system the contents
#   will **NOT** be replaced by the contents from maincf_source.
#   Example: `puppet:///modules/some/other/location/main.cf`.
#
# @param manage_aliases
#   Manage /etc/aliases file
#
# @param manage_conffiles
#   A Boolean defining whether the puppet module should replace the configuration files for postfix.
#   This setting currently effects only the following files:
#   - /etc/mailname
#   - /etc/postfix/master.cf
#
#   This setting does NOT effect the following files:
#   - /etc/aliases
#   - /etc/postfix/main.cf
#
# @param manage_mailname
#   A Boolean defining whether the puppet module should manage '/etc/mailname'.
#   See also $manage_conffiles
#
# @param manage_mailx
#   A Boolean defining whether the puppet module should manage the mailx package. See also $mailx_ensure.
#
# @param mailx_package
#   Name of package that provides mailx
#
# @param manage_root_alias
#   Wheter to manage the mailalias for root user
#
# @param maps
#   A hash of postfix::map resources
#
# @param master_bounce_command
#   The bounce command which should be used in master.cf
#
# @param master_defer_command
#   The defer command which should be used in master.cf
#
# @param master_os_template
#   Path to the master template
#
# @param master_entries
#   Array of strings containing additional entries for the /etc/postfix/master.cf file.
#   Example: `['submission inet n       -       n       -       -       smtpd']`.
#
# @param master_smtp
#   A string to define the smtp line in the /etc/postfix/master.cf file.
#   If this is defined the smtp_listen parameter will be ignored.
#   Example: `smtp      inet  n       -       n       -       -       smtpd`.
#
# @param master_smtps
#   A string to define the smtps line in the /etc/postfix/master.cf file.
#   Example: `smtps     inet  n       -       n       -       -       smtpd`.
#
# @param master_submission
#   A string to define the submission line in the /etc/postfix/master.cf file.
#   Example: `submission inet n       -       n       -       -       smtpd`.
#
# @param mastercf_content
#   Set the content parameter for the master.cf file resource.
#
# @param mastercf_source
#   A string defining the location of a skeleton master.cf file to be used.
#   Example: `puppet:///modules/some/other/location/master.cf`.
#
# @param mastercf_template
#   Set the epp template path which will be used for master.cf file resource.
#
# @param masquerade_classes
#   Postfix config parameter masquerade_classes as an array.
#   What addresses are subject to address masquerading.
#   Example: `['envelope_sender', 'envelope_recipient', 'header_sender', 'header_recipient']`
#
#
# @param masquerade_domains
#   An array defining the masquerade_domains to use.
#   The order of elements matters here, so be aware of how you define the elements.
#   Example: `['foo.example.com', 'example.com']`
#
# @param masquerade_exceptions
#   An array defining the masquerade_exceptions to use. This optional list of user names that are not
#   subjected to address masquerading, even when their addresses match $masquerade_domains.
#   Example: `['root']`
#
# @param mta_bin_path
#   An optional path for mta 'alternative'.
#   Example: `'/usr/sbin/sendmail.postfix'`
#
# @param mta
#   A Boolean to define whether to configure Postfix as a mail transfer agent.
#   This option is mutually exclusive with the satellite Boolean.
#
# @param mydestination
#   A string to define the mydestination parameter in main.cf (postconf(5)).
#   Example: `example.com, foo.example.com`.
#
# @param mynetworks
#   A string to define the mynetworks parameter that holds trusted remote smtp clients (postconf(5)).
#   Example: `127.0.0.0/8, [::1]/128`.
#
# @param myorigin
#   A string to define the myorigin parameter that holds the domain name that mail appears to come from (postconf(5)).
#   Example: `example.com`
#
# @param postfix_ensure
#   The ensure value of the postfix package
#
# @param relayhost
#   A string to define the relayhost parameter (postconf(5)).
#   Example: `smtp.example.com`.
#
# @param root_group
#   The group permission name for the main.cf and master.cf files.
#
# @param root_mail_recipient
#   A string to define the e-mail address to which all mail directed to root should go (aliases(5)).
#   Example: `root_catch@example.com`.
#
# @param satellite
#   A Boolean to define whether to configure Postfix as a satellite relay host.
#   This setting is mutually exclusive with the mta Boolean.
#
# @param service_enabled
#   Defines if the service 'postfix' is enabled on the system
#
# @param service_ensure
#   Defines the service state of 'postfix' service
#
# @param restart_cmd
#   Command to use when restarting postfix
#
# @param smtp_listen
#   A string or an array of strings to define the IPs on which to listen in master.cf.
#   This can also be set to 'all' to listen on all interfaces. If master_smtp is defined
#   smtp_listen will not be used.
#   Example: `::1`.
#
# @param transports
#   A hash of postfix::transport resources
#
# @param use_amavisd
#   A Boolean to define whether to configure master.cf to allow the use of the amavisd scanner.
#
# @param use_dovecot_lda
#   A Boolean to define whether to configure master.cf to use dovecot as the local delivery agent.
#
# @param use_schleuder
#   A Boolean to define whether to configure master.cf to use the Schleuder GPG-enabled mailing list.
#   Can be also set to an integer `2` to use Schleuder v2 instead of v3.
#
# @param use_sympa
#   A Boolean to define whether to configure master.cf to use the Sympa mailing list management software.
#
# @param virtuals
#   A hash of postfix::virtual resources
#
# @param aliasesseltype
#   Selinux type for /etc/aliases
#
# @param seltype
#   Selinux type for /etc/postfix/* config files
#
class postfix (
  String                               $alias_maps,
  Integer                              $amavis_procs,
  Stdlib::Absolutepath                 $confdir,
  Hash                                 $conffiles,
  Hash                                 $configs,
  Hash                                 $hashes,
  String                               $inet_interfaces,
  String                               $inet_protocols,
  Boolean                              $ldap,
  Array[String[1]]                     $ldap_packages,
  String                               $lookup_table_type,
  Hash                                 $mailaliases,
  String                               $mail_user,             # postfix_mail_user
  Boolean                              $mailman,
  String                               $mailx_ensure,
  String                               $mailx_package,
  String                               $maincf_source,
  Boolean                              $manage_aliases,        # /etc/aliases
  Boolean                              $manage_conffiles,
  Boolean                              $manage_mailname,
  Boolean                              $manage_mailx,
  Boolean                              $manage_root_alias,
  Hash                                 $maps,
  String                               $master_bounce_command,
  String                               $master_defer_command,
  String                               $master_os_template,
  Array[String]                        $master_entries,        # postfix_master_entries
  Boolean                              $mta,
  String                               $mydestination,         # postfix_mydestination
  String                               $mynetworks,            # postfix_mynetworks
  String                               $myorigin,
  String                               $postfix_ensure,
  String                               $root_group,
  Variant[Array[String], String]       $root_mail_recipient,   # root_mail_recipient
  Boolean                              $satellite,
  Boolean                              $service_enabled,
  String                               $service_ensure,
  String                               $restart_cmd,
  Variant[Array[String[1]], String[1]] $smtp_listen,           # postfix_smtp_listen
  Hash                                 $transports,
  Boolean                              $use_amavisd,           # postfix_use_amavisd
  Boolean                              $use_dovecot_lda,       # postfix_use_dovecot_lda
  Variant[Integer[2, 3], Boolean]      $use_schleuder,         # postfix_use_schleuder
  Boolean                              $use_sympa,             # postfix_use_sympa
  Hash                                 $virtuals,

  Optional[Boolean]                    $chroot                = undef,
  Optional[String]                     $ldap_base             = undef,
  Optional[String]                     $ldap_host             = undef,
  Optional[String]                     $ldap_options          = undef,
  Optional[String]                     $master_smtp           = undef, # postfix_master_smtp
  Optional[String]                     $master_smtps          = undef, # postfix_master_smtps
  Optional[String]                     $master_submission     = undef, # postfix_master_submission
  Optional[String]                     $mastercf_content      = undef,
  Optional[String]                     $mastercf_source       = undef,
  Optional[String]                     $mastercf_template     = undef,
  Optional[Array[String[1]]]           $masquerade_classes    = undef,
  Optional[Array[String[1]]]           $masquerade_domains    = undef,
  Optional[Array[String[1]]]           $masquerade_exceptions = undef,
  Optional[Stdlib::Absolutepath]       $mta_bin_path          = undef,
  Optional[String]                     $relayhost             = undef, # postfix_relayhost
  Optional[String]                     $aliasesseltype        = undef,
  Optional[String]                     $seltype               = undef,
) {
  if (
    ($mastercf_source and $mastercf_content) or
    ($mastercf_source and $mastercf_template) or
    ($mastercf_content and $mastercf_template) or
    ($mastercf_source and $mastercf_content and $mastercf_template)
  ) {
    fail('mastercf_source, mastercf_content and mastercf_template are mutually exclusive')
  }

  $_smtp_listen = $mailman ? {
    true    => '0.0.0.0',
    default => $smtp_listen,
  }

  $all_alias_maps = $ldap ? {
    false => $alias_maps,
    true  => "${alias_maps}, ldap:${confdir}/ldap-aliases.cf",
  }

  $configs.each |$key, $value| {
    postfix::config { $key:
      * => $value,
    }
  }

  $mailaliases.each |$key, $value| {
    postfix::mailalias { $key:
      * => $value,
    }
  }

  $transports.each |$key, $value| {
    postfix::transport { $key:
      * => $value,
    }
  }

  $virtuals.each |$key, $value| {
    postfix::virtual { $key:
      * => $value,
    }
  }

  $hashes.each |$key, $value| {
    postfix::hash { $key:
      * => $value,
    }
  }

  $conffiles.each |$key, $value| {
    postfix::conffile { $key:
      * => $value,
    }
  }

  $maps.each |$key, $value| {
    postfix::map { $key:
      * => $value,
    }
  }

  contain 'postfix::packages'
  contain 'postfix::files'
  contain 'postfix::service'

  Class['postfix::packages']
  -> Class['postfix::files']
  ~> Class['postfix::service']

  if $ldap {
    include postfix::ldap
  }

  if $mta {
    if $satellite {
      fail('enabling both the $mta and $satellite parameters is not supported. Please disable one.')
    }
    include postfix::mta
  }

  if $satellite {
    if $mta {
      fail('enabling both the $mta and $satellite parameters is not supported. Please disable one.')
    }
    include postfix::satellite
  }

  if $mailman {
    include postfix::mailman
  }
}
