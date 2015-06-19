require 'beaker-rspec'
require 'beaker_spec_helper'

include BeakerSpecHelper

hosts.each do |host|
  install_puppet_on host
  install_package host, 'git'
  install_package host, 'tar'
  install_package host, 'sudo'
  on host, 'rm /usr/sbin/policy-rc.d || true'
end

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  module_name = module_root.split('-').last

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => module_root, :module_name => module_name)
    hosts.each do |host|
      BeakerSpecHelper::spec_prep(host)
    end
  end
end
