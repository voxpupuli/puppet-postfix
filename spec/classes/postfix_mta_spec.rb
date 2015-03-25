require 'spec_helper'

describe 'postfix::mta' do
  let (:facts) { {
    :lsbdistcodename => 'wheezy',
    :osfamily        => 'Debian',
    :path            => '/foo/bar',
  } }
  let :pre_condition do
    "class { 'postfix':
      mydestination => 'bar',
      mynetworks    => '127.0.0.1/8, [::1]/128 ![::2]/128',
      relayhost     => 'foo',
    }"
  end

  it { is_expected.to contain_postfix__config('mydestination').with_value('bar') }
  it { is_expected.to contain_postfix__config('mynetworks').with_value('127.0.0.1/8, [::1]/128 ![::2]/128') }
  it { is_expected.to contain_postfix__config('relayhost').with_value('foo') }
end
