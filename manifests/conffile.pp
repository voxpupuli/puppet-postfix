# = Define: postfix::conffile
#
# Adds a postfix configuration file.
# It is mainly a file resource that also restarts postfix
#
# == Parameters
#
# [*ensure*]
#   Ensure parameter for the file resource. Defaults to 'present'
#
# [*source*]
#   Sets the value of the source parameter for the file
#
# [*content*]
#   Sets the content of the postfix config file
#   Note: This option is alternative to the source one
#
# [*path*]
#   Where to create the file.
#   Defaults to "/etc/postfix/${name}".
#
# [*mode*]
#   The file permissions of the file.
#   Defaults to 0644
#
# [*options*]
#   Hash with options to use in the template
#
# == Usage:
# postfix::conffile { 'ldapoptions.cf':
#   options            => {
#     server_host      => <ldapserver>,
#     bind             => 'yes',
#     bind_dn          => <bind_dn>,
#     bind_pw          => <bind_pw>,
#     search_base      => 'dc=example, dc=com',
#     query_filter     => 'mail=%s',
#     result_attribute => 'uid',
#   }
# }
#
# postfix::conffile { 'ldapoptions.cf':
#   source => 'puppet:///modules/postfix/ldapoptions.cf',
# }
#
define postfix::conffile (
  $ensure   = 'present',
  $source   = undef,
  $content  = undef,
  $path     = "/etc/postfix/${name}",
  $mode     = '0644',
  $options  = {},
) {
  include ::postfix::params

  validate_absolute_path($path)
  if !is_string($source) and !is_array($source) { fail("value for source should be either String type or Array type got ${source}") }
  if !is_string($content) { fail("value for content should be String type; got ${content}") }
  validate_re($ensure, ['present', 'absent', 'directory'],
    "\$ensure must be either 'present', 'absent' or 'directory', got '${ensure}'")
  validate_hash($options)

  if (!defined(Class['postfix'])) {
    fail 'You must define class postfix before using postfix::config!'
  }

  if $source and $content {
    fail 'You must provide either \'source\' or \'content\', not both'
  }

  validate_hash($options)
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
    ensure  => $ensure,
    path    => $path,
    mode    => $mode,
    owner   => 'root',
    group   => 'postfix',
    seltype => $postfix::params::seltype,
    require => Package['postfix'],
    source  => $source,
    content => $manage_content,
    notify  => Service['postfix'],
  }

}
