require 'spec_helper'

describe 'postfix::augeas' do
  let :pre_condition do
    'include ::augeas'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(augeasversion: '1.2.0',
                    puppetversion: Puppet.version)
      end

      it { is_expected.to compile.with_all_deps }

      it {
        is_expected.to contain_augeas__lens('postfix_transport').with(ensure: 'present',
                                                                      lens_content: %r{Parses /etc/postfix/transport},
                                                                      test_content: %r{Provides unit tests and examples for the <Postfix_Transport> lens.},
                                                                      stock_since: '1.0.0')
      }
      it {
        is_expected.to contain_augeas__lens('postfix_virtual').with(ensure: 'present',
                                                                    lens_content: %r{Parses /etc/postfix/virtual},
                                                                    test_content: %r{Provides unit tests and examples for the <Postfix_Virtual> lens.},
                                                                    stock_since: '1.7.0')
      }
    end
  end
end
