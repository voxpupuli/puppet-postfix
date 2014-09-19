require 'spec_helper'

describe 'postfix::mta' do
  let (:facts) { {
    :lsbdistcodename => 'wheezy',
    :osfamily        => 'Debian',
  } }
  let :pre_condition do
    "class { 'postfix':
      mydestination => 'bar',
      mynetworks    => 'baz',
      relayhost     => 'foo',
    }"
  end

  it { should contain_postfix__config('mydestination').with_value('bar') }
  it { should contain_postfix__config('mynetworks').with_value('baz') }
  it { should contain_postfix__config('relayhost').with_value('foo') }
end
