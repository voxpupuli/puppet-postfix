require 'spec_helper'

describe 'postfix::config' do
  let (:title) { 'foo' }
  let (:facts) { {
    :osfamily => 'Debian',
    :needs_postfix_class => true,
  } }

  context 'when not passing value' do
    it 'should fail' do
      expect {
        should contain_augeas("set postfix 'foo'")
      }.to raise_error(Puppet::Error, /Must pass value to Postfix::Config/)
    end
  end

  context 'when passing wrong type for value' do
    let (:params) { {
      :value => ['bar'],
    } }
    it 'should fail' do
      expect {
        should contain_augeas("set postfix 'foo'")
      }.to raise_error(Puppet::Error, /\["bar"\] is not a string/)
    end
  end

  context 'when passing wrong type for ensure' do
    let (:params) { {
      :value  => 'bar',
      :ensure => ['present'],
    } }
    it 'should fail' do
      expect {
        should contain_augeas("set postfix 'foo'")
      }.to raise_error(Puppet::Error, /\["present"\] is not a string/)
    end
  end

  context 'when passing wrong value for ensure' do
    let (:params) { {
      :value  => 'bar',
      :ensure => 'running',
    } }
    it 'should fail' do
      expect {
        should contain_augeas("set postfix 'foo'")
      }.to raise_error(Puppet::Error, /must be either 'present' or 'absent'/)
    end
  end

  context 'when ensuring presence' do
    let (:params) { {
      :value  => 'bar',
      :ensure => 'present',
    } }

    it { should contain_augeas("set postfix 'foo' to 'bar'").with(
      :incl    => '/etc/postfix/main.cf',
      :lens    => 'Postfix_Main.lns',
      :changes => "set foo 'bar'"
    ) }
  end

  context 'when ensuring absence' do
    let (:params) { {
      :value  => 'bar',
      :ensure => 'absent',
    } }

    it { should contain_augeas("rm postfix 'foo'").with(
      :incl    => '/etc/postfix/main.cf',
      :lens    => 'Postfix_Main.lns',
      :changes => "rm foo"
    ) }
  end
end
