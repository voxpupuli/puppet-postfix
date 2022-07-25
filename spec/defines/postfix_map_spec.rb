# frozen_string_literal: true

require 'spec_helper'

describe 'postfix::map' do
  let(:title) { 'foo' }

  let :pre_condition do
    "class { '::postfix': }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:postfix_foo_db_path) do
        case facts[:osfamily]
        when 'FreeBSD' then '/usr/local/etc/postfix/foo.db'
        else '/etc/postfix/foo.db'
        end
      end

      let(:facts) do
        facts
      end

      context 'when passing wrong value for ensure' do
        let(:params) do
          {
            ensure: 'running',
          }
        end

        it 'fails' do
          expect do
            is_expected.to contain_file('postfix map foo')
          end.to raise_error(Puppet::Error, %r{got 'running'})
        end
      end

      context 'when passing both source and content' do
        let(:params) do
          {
            source: '/tmp/bar',
            content: 'bar',
          }
        end

        it 'fails' do
          expect do
            is_expected.to contain_file('postfix map foo')
          end.to raise_error(Puppet::Error, %r{You must provide either 'source' or 'content'})
        end
      end

      context 'when passing source' do
        let(:params) do
          {
            source: '/tmp/bar',
          }
        end

        it {
          is_expected.to contain_file('postfix map foo').with(
            ensure: 'present',
            source: '/tmp/bar'
          ).without(:content)
        }

        it { is_expected.to contain_file('postfix map foo.db').with_ensure('present') }
        it { is_expected.to contain_exec('generate foo.db') }
      end

      context 'when passing content' do
        let(:params) do
          {
            content: 'bar',
          }
        end

        it {
          is_expected.to contain_file('postfix map foo').with(
            ensure: 'present',
            content: 'bar'
          ).without(:source)
        }

        it { is_expected.to contain_file('postfix map foo.db').with_ensure('present') }
        it { is_expected.to contain_exec('generate foo.db') }
      end

      context 'when not passing source or content' do
        it {
          is_expected.to contain_file('postfix map foo').with(
            ensure: 'present'
          ).without(:source).without(:content)
        }

        it { is_expected.to contain_file('postfix map foo.db').with_ensure('present') }
        it { is_expected.to contain_exec('generate foo.db') }
      end

      context 'when ensuring absence' do
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it { is_expected.to contain_file('postfix map foo').with_ensure('absent') }
        it { is_expected.to contain_file('postfix map foo').without_notify }
        it { is_expected.to contain_file('postfix map foo.db').with_ensure('absent') }
        it { is_expected.to contain_exec('generate foo.db').with(command: "rm #{postfix_foo_db_path}") }
      end

      context 'when using pcre type' do
        let(:params) do
          {
            type: 'pcre',
          }
        end

        it { is_expected.to contain_file('postfix map foo').with_ensure('present') }
        it { is_expected.not_to contain_file('postfix map foo.db') }
      end

      context 'when using cidr type' do
        let(:params) do
          {
            type: 'cidr',
          }
        end

        it { is_expected.to contain_file('postfix map foo').with_ensure('present') }
        it { is_expected.not_to contain_file('postfix map foo.db') }
      end

      context 'when using regexp type' do
        let(:params) do
          {
            type: 'regexp',
          }
        end

        it { is_expected.to contain_file('postfix map foo').with_ensure('present') }
        it { is_expected.not_to contain_file('postfix map foo.db') }
      end

      context 'when passing cdb type' do
        let(:params) do
          {
            type: 'cdb',
          }
        end

        it { is_expected.to contain_file('postfix map foo').with_ensure('present') }
        it { is_expected.to contain_file('postfix map foo.cdb').with_ensure('present') }
        it { is_expected.to contain_exec('generate foo.cdb') }
      end
    end
  end
end
