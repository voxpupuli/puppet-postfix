require 'spec_helper'

describe 'postfix::augeas' do
  let (:facts) { {
    :operatingsystem => 'Debian',
    :osfamily        => 'Debian',
  } }

  it { should contain_augeas__lens('postfix_transport').with(
    :ensure      => 'present',
    :lens_source => 'puppet:///modules/postfix/lenses/postfix_transport.aug',
    :test_source => 'puppet:///modules/postfix/lenses/test_postfix_transport.aug',
    :stock_since => '1.0.0'
  ) }
  it { should contain_augeas__lens('postfix_virtual').with(
    :ensure      => 'present',
    :lens_source => 'puppet:///modules/postfix/lenses/postfix_virtual.aug',
    :test_source => 'puppet:///modules/postfix/lenses/test_postfix_virtual.aug',
    :stock_since => '1.0.0'
  ) }
end
