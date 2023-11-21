if fact('os.name') == 'Debian' and !fact('aio_agent_version') {
  package { ['puppet-module-puppetlabs-augeas-core', 'puppet-module-puppetlabs-mailalias-core']:
    ensure => present,
  }
}
