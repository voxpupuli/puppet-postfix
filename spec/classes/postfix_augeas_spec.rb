require 'spec_helper'

describe 'postfix::augeas' do

  let :pre_condition do
    "include ::augeas"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :augeasversion => '1.2.0',
        })
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_augeas__lens('postfix_transport').with({
        :ensure      => 'present',
        :lens_source => 'puppet:///modules/postfix/lenses/postfix_transport.aug',
        :test_source => 'puppet:///modules/postfix/lenses/test_postfix_transport.aug',
        :stock_since => '1.0.0',
      } ) }
      it { is_expected.to contain_augeas__lens('postfix_virtual').with({
        :ensure      => 'present',
        :lens_source => 'puppet:///modules/postfix/lenses/postfix_virtual.aug',
        :test_source => 'puppet:///modules/postfix/lenses/test_postfix_virtual.aug',
        :stock_since => '1.0.0',
      }) }
    end
  end
end
