require 'spec_helper'

describe 'postfix::satellite' do
  let :pre_condition do
    " class { 'augeas': }
    class { 'postfix':
      relayhost     => 'foo',
      mydestination => 'bar',
      mynetworks    => 'baz',
    }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(augeasversion: '1.2.0',
                    puppetversion: Puppet.version)
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('postfix::mta') }
      it {
        is_expected.to contain_postfix__virtual('@foo.example.com').with(
          ensure: 'present',
          destination: 'root',
        )
      }
    end
  end
end
