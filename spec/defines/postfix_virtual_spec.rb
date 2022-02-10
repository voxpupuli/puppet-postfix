# frozen_string_literal: true

require 'spec_helper'

describe 'postfix::virtual' do
  let(:title) { 'foo' }

  let :pre_condition do
    <<-EOT
    class { '::augeas': }
    class { '::postfix': }
    EOT
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:postfix_virutal_path) do
        case facts[:osfamily]
        when 'FreeBSD' then '/usr/local/etc/postfix/virtual'
        else '/etc/postfix/virtual'
        end
      end

      let(:facts) do
        facts.merge(augeasversion: '1.2.0',
                    puppetversion: Puppet.version)
      end

      context 'when not sending destination' do
        it 'fails' do
          expect do
            is_expected.to contain_augeas('Postfix virtual - foo')
          end.to raise_error(Puppet::Error, %r{destination})
        end
      end

      context 'when sending wrong value for file' do
        let(:params) do
          {
            destination: 'bar',
            file: 'baz',
          }
        end

        it 'fails' do
          expect do
            is_expected.to contain_augeas('Postfix virtual - foo')
          end.to raise_error(Puppet::Error, %r{, got })
        end
      end

      context 'when sending wrong value for ensure' do
        let(:params) do
          {
            destination: 'bar',
            ensure: 'running',
          }
        end

        it 'fails' do
          expect do
            is_expected.to contain_augeas('Postfix virtual - foo')
          end.to raise_error(Puppet::Error, %r{got 'running'})
        end
      end

      context 'when using default values' do
        let(:params) do
          {
            destination: 'bar',
          }
        end

        it { is_expected.to contain_class('postfix::augeas') }

        it {
          is_expected.to contain_augeas('Postfix virtual - foo').with(
            incl: postfix_virutal_path,
            lens: 'Postfix_Virtual.lns',
            changes: [
              "defnode entry pattern[. = 'foo'] 'foo'",
              'rm $entry/destination',
              "set $entry/destination[1] 'bar'",
            ]
          )
        }
      end

      context 'when overriding default values' do
        let(:params) do
          {
            destination: 'bar',
            file: '/tmp/virtual',
            ensure: 'present',
          }
        end

        it { is_expected.to contain_class('postfix::augeas') }

        it {
          is_expected.to contain_augeas('Postfix virtual - foo').with(
            incl: '/tmp/virtual',
            lens: 'Postfix_Virtual.lns',
            changes: [
              "defnode entry pattern[. = 'foo'] 'foo'",
              'rm $entry/destination',
              "set $entry/destination[1] 'bar'",
            ]
          )
        }
      end

      context 'when passing destination as array' do
        let(:params) do
          {
            destination: %w[bar baz],
            file: '/tmp/virtual',
            ensure: 'present',
          }
        end

        it { is_expected.to contain_class('postfix::augeas') }

        it {
          is_expected.to contain_augeas('Postfix virtual - foo').with(
            incl: '/tmp/virtual',
            lens: 'Postfix_Virtual.lns',
            changes: [
              "defnode entry pattern[. = 'foo'] 'foo'",
              'rm $entry/destination',
              "set $entry/destination[1] 'bar'",
              "set $entry/destination[2] 'baz'",
            ]
          )
        }
      end

      context 'when ensuring absence' do
        let(:params) do
          {
            destination: 'bar',
            ensure: 'absent',
          }
        end

        it { is_expected.to contain_class('postfix::augeas') }

        it {
          is_expected.to contain_augeas('Postfix virtual - foo').with(
            incl: postfix_virutal_path,
            lens: 'Postfix_Virtual.lns',
            changes: [
              "rm pattern[. = 'foo']",
            ]
          )
        }
      end
    end
  end
end
