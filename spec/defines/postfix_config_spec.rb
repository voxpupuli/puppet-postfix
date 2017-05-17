require 'spec_helper'

describe 'postfix::config' do
  let (:title) { 'foo' }

  let :pre_condition do
    "class { 'postfix': }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'when not passing value' do
        it 'should fail' do
          expect {
            is_expected.to contain_augeas("set postfix 'foo'")
          }.to raise_error
        end
      end

      context 'when passing wrong type for value' do
        let (:params) { {
          :value => ['bar'],
        } }
        it 'should fail' do
          expect {
            is_expected.to contain_augeas("set postfix 'foo'")
          }.to raise_error
        end
      end

      context 'when passing wrong type for ensure' do
        let (:params) { {
          :value  => 'bar',
          :ensure => ['present'],
        } }
        it 'should fail' do
          expect {
            is_expected.to contain_augeas("set postfix 'foo'")
          }.to raise_error
        end
      end

      context 'when passing wrong value for ensure' do
        let (:params) { {
          :value  => 'bar',
          :ensure => 'running',
        } }
        it 'should fail' do
          expect {
            is_expected.to contain_augeas("set postfix 'foo'")
          }.to raise_error(Puppet::Error, /got 'running'/)
        end
      end

      context 'when ensuring presence' do
        let (:params) { {
          :value  => 'bar',
          :ensure => 'present',
        } }

        it { is_expected.to contain_augeas("manage postfix 'foo'").with(
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

        it { is_expected.to contain_augeas("manage postfix 'foo'").with(
          :incl    => '/etc/postfix/main.cf',
          :lens    => 'Postfix_Main.lns',
          :changes => "rm foo"
        ) }
      end

      context 'when ensuring blank' do
        let (:params) { {
          :value  => 'bar',
          :ensure => 'blank',
        } }

        it { is_expected.to contain_augeas("manage postfix 'foo'").with(
          :incl    => '/etc/postfix/main.cf',
          :lens    => 'Postfix_Main.lns',
          :changes => "clear foo"
        ) }
      end
    end
  end
end
