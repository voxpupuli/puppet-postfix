require 'spec_helper'

describe 'postfix::satellite' do
  let (:node) { 'foo.example.com' }
  let (:facts) { {
    :augeasversion   => '1.2.0',
    :lsbdistcodename => 'wheezy',
    :osfamily        => 'Debian',
    :rubyversion     => '1.9.3',
  } }
  let :pre_condition do
    " class { 'augeas': }
    class { 'postfix':
      relayhost     => 'foo',
      mydestination => 'bar',
      mynetworks    => 'baz',
    }"
  end
  it { should contain_class('postfix::mta') }
  it { should contain_postfix__virtual('@foo.example.com').with(
    :ensure      => 'present',
    :destination => 'root'
  ) }
end
