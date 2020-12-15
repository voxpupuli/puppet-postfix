require 'spec_helper'

describe 'postfix::config' do
  let(:title) { 'foo' }

  let :pre_condition do
    "class { 'postfix': }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'when not passing value while ensure present' do
        let(:params) do
          {
            ensure: 'present',
          }
        end

        it 'fails' do
          expect {
            is_expected.to contain_augeas("manage postfix 'foo'")
          }.to raise_error(Exception, %r{can not be empty if ensure = present})
        end
      end

      context 'when passing wrong type for value' do
        let(:params) do
          {
            value: ['bar'],
          }
        end

        it 'fails' do
          expect {
            is_expected.to contain_augeas("manage postfix 'foo'")
          }.to raise_error(Exception, %r{got Tuple})
        end
      end

      context 'when passing wrong type for ensure' do
        let(:params) do
          {
            value: 'bar',
            ensure: ['present'],
          }
        end

        it 'fails' do
          expect {
            is_expected.to contain_augeas("manage postfix 'foo'")
          }.to raise_error(Exception, %r{got Tuple})
        end
      end

      context 'when passing wrong value for ensure' do
        let(:params) do
          {
            value: 'bar',
            ensure: 'running',
          }
        end

        it 'fails' do
          expect {
            is_expected.to contain_augeas("manage postfix 'foo'")
          }.to raise_error(Puppet::Error, %r{got 'running'})
        end
      end

      context 'when ensuring presence' do
        let(:params) do
          {
            value: 'bar',
            ensure: 'present',
          }
        end

        it {
          is_expected.to contain_augeas("manage postfix 'foo'").with(
            incl: '/etc/postfix/main.cf',
            lens: 'Postfix_Main.lns',
            changes: "set foo 'bar'",
          )
        }
      end

      context 'when ensuring absence' do
        let(:params) do
          {
            value: 'bar',
            ensure: 'absent',
          }
        end

        it {
          is_expected.to contain_augeas("manage postfix 'foo'").with(
            incl: '/etc/postfix/main.cf',
            lens: 'Postfix_Main.lns',
            changes: 'rm foo',
          )
        }
      end

      context 'when ensuring blank' do
        let(:params) do
          {
            value: 'bar',
            ensure: 'blank',
          }
        end

        it {
          is_expected.to contain_augeas("manage postfix 'foo'").with(
            incl: '/etc/postfix/main.cf',
            lens: 'Postfix_Main.lns',
            changes: 'clear foo',
          )
        }
      end

      # Non ensure checks
      context 'when not ensuring and value string' do
        let(:params) do
          {
            value: 'bar',
          }
        end

        it {
          is_expected.to contain_augeas("manage postfix 'foo'").with(
            incl: '/etc/postfix/main.cf',
            lens: 'Postfix_Main.lns',
            changes: "set foo 'bar'",
          )
        }
      end

      context 'when not ensuring and value empty' do
        let(:params) do
          {
            value: '',
          }
        end

        it {
          is_expected.to contain_augeas("manage postfix 'foo'").with(
            incl: '/etc/postfix/main.cf',
            lens: 'Postfix_Main.lns',
            changes: 'clear foo',
          )
        }
      end

      context 'when not ensuring and value undef' do
        it {
          is_expected.to contain_augeas("manage postfix 'foo'").with(
            incl: '/etc/postfix/main.cf',
            lens: 'Postfix_Main.lns',
            changes: 'rm foo',
          )
        }
      end
    end
  end
end
