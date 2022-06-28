# @summary Manage a Postfix configuration file
#
# Manages Postfix configuration files. With it, you could create configuration
# files (other than, main.cf, master.cf, etc.) restarting Postfix when necessary.
#
# @example Simple config file with module source
#   postfix::conffile { 'ldapoptions.cf':
#     source => 'puppet:///modules/postfix/ldapoptions.cf',
#   }
#
# @example With template options
#   postfix::conffile { 'ldapoptions.cf':
#     options            => {
#       server_host      => ldap.mydomain.com,
#       bind             => 'yes',
#       bind_dn          => 'cn=admin,dc=mydomain,dc=com',
#       bind_pw          => 'password',
#       search_base      => 'dc=example, dc=com',
#       query_filter     => 'mail=%s',
#       result_attribute => 'uid',
#     }
#   }
#
# @param ensure
#   A string whose valid values are present, absent or directory.
#
# @param source
#   A string with the source of the file. This is the `source` parameter of the underlying file resource.
#   Example: `puppet:///modules/postfix/configfile.cf`
#
# @param content
#   The content of the Postfix configuration file. This is an alternative to the `source` parameter.
#   If you don't provide `source` neither `content` parameters a default template is used and the
#   content is created with values in the `options` hash.
#
# @param path
#   Where to create the file. If not defined "${postfix::confdir}/${name}" will be used as path.
#
# @param mode
#   Permissions of the configuration file. This option is useful if you want to create the file with
#   specific permissions (for example, because you have passwords in it).
#   Example: `0640`
#
# @param options
#   Hash with the options used in the default template that is used when neither `source`
#   neither `content`parameters are provided.
#
# @param show_diff
#   Switch to set file show_diff parameter
#
define postfix::conffile (
  Enum['present', 'absent', 'directory'] $ensure    = 'present',
  Variant[Array[String], String, Undef]  $source    = undef,
  Optional[String]                       $content   = undef,
  Optional[Stdlib::Absolutepath]         $path      = undef,
  String                                 $mode      = '0640',
  Hash                                   $options   = {},
  Boolean                                $show_diff = true,
) {
  include postfix

  $_path = pick($path, "${postfix::confdir}/${name}")

  if (!defined(Class['postfix'])) {
    fail 'You must define class postfix before using postfix::config!'
  }

  if $source and $content {
    fail 'You must provide either \'source\' or \'content\', not both'
  }

  if !$source and !$content and $ensure == 'present' and empty($options) {
    fail 'You must provide \'options\' hash parameter if you don\'t provide \'source\' neither \'content\''
  }

  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_content = $content ? {
    undef   => $source ? {
      undef   => template('postfix/conffile.erb'),
      default => undef,
    },
    default => $content,
  }

  file { "postfix conffile ${name}":
    ensure    => $ensure,
    path      => $_path,
    mode      => $mode,
    owner     => 'root',
    group     => 'postfix',
    seltype   => $postfix::params::seltype,
    require   => Package['postfix'],
    source    => $source,
    content   => $manage_content,
    show_diff => $show_diff,
    notify    => Service['postfix'],
  }
}
