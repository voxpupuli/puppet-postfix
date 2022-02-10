# frozen_string_literal: true

require 'spec_helper'

describe 'postfix::config' do
  let(:title) { 'foo' }

  let :pre_condition do
    "class { 'postfix': }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:postfix_main_cf_path) do
        case facts[:osfamily]
        when 'FreeBSD' then '/usr/local/etc/postfix/main.cf'
        else '/etc/postfix/main.cf'
        end
      end
      let(:facts) do
        facts
      end

      context 'when not passing value' do
        it 'fails' do
          expect do
            is_expected.to contain_augeas("set postfix 'foo'")
          end.to raise_error(Puppet::Error, %r{can not be empty if ensure = present})
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
          expect do
            is_expected.to contain_augeas("set postfix 'foo'")
          end.to raise_error(Puppet::Error, %r{got 'running'})
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
            incl: postfix_main_cf_path,
            lens: 'Postfix_Main.lns',
            changes: "set foo 'bar'"
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
            incl: postfix_main_cf_path,
            lens: 'Postfix_Main.lns',
            changes: 'rm foo'
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
            incl: postfix_main_cf_path,
            lens: 'Postfix_Main.lns',
            changes: 'clear foo'
          )
        }
      end
    end
  end
end
