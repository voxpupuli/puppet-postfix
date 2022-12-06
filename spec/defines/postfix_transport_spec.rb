# frozen_string_literal: true

require 'spec_helper'

describe 'postfix::transport' do
  let(:title) { 'foo' }

  let :pre_condition do
    <<-EOT
    class { '::augeas': }
    class { '::postfix': }
    EOT
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:postfix_transport_path) do
        case facts[:osfamily]
        when 'FreeBSD' then '/usr/local/etc/postfix/transport'
        else '/etc/postfix/transport'
        end
      end

      let(:facts) do
        facts.merge(augeasversion: '1.2.0',
                    puppetversion: Puppet.version)
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
            is_expected.to contain_augeas('Postfix transport - foo')
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
            is_expected.to contain_augeas('Postfix transport - foo')
          end.to raise_error(Puppet::Error, %r{got 'running'})
        end
      end

      context 'when using default values' do
        it { is_expected.to contain_class('postfix::augeas') }

        it {
          is_expected.to contain_augeas('Postfix transport - foo').with(
            incl: postfix_transport_path,
            lens: 'Postfix_Transport.lns',
            changes: [
              "set pattern[. = 'foo'] 'foo'",
              "clear pattern[. = 'foo']/transport",
              "clear pattern[. = 'foo']/nexthop",
              "rm pattern[. = 'foo']/host",
              "rm pattern[. = 'foo']/port",
            ]
          )
        }
      end

      context 'when overriding default values' do
        let(:params) do
          {
            destination: 'bar',
            nexthop: 'baz',
            file: '/tmp/transport',
            ensure: 'present',
          }
        end

        it { is_expected.to contain_class('postfix::augeas') }

        it {
          is_expected.to contain_augeas('Postfix transport - foo').with(
            incl: '/tmp/transport',
            lens: 'Postfix_Transport.lns',
            changes: [
              "set pattern[. = 'foo'] 'foo'",
              "set pattern[. = 'foo']/transport 'bar'",
              "rm pattern[. = 'foo']/host",
              "rm pattern[. = 'foo']/port",
              "set pattern[. = 'foo']/nexthop 'baz'",
            ]
          )
        }
      end

      context 'when overriding nexthop with [host]' do
        let(:params) do
          {
            nexthop: '[baz]',
            file: '/tmp/transport',
            ensure: 'present',
          }
        end

        it { is_expected.to contain_class('postfix::augeas') }

        it {
          is_expected.to contain_augeas('Postfix transport - foo').with(
            incl: '/tmp/transport',
            lens: 'Postfix_Transport.lns',
            changes: [
              "set pattern[. = 'foo'] 'foo'",
              "rm pattern[. = 'foo']/transport",
              "rm pattern[. = 'foo']/host",
              "rm pattern[. = 'foo']/port",
              "set pattern[. = 'foo']/nexthop '[baz]'",
            ]
          )
        }
      end

      context 'when overriding nexthop with :[host]' do
        let(:params) do
          {
            nexthop: ':[baz]',
            file: '/tmp/transport',
            ensure: 'present',
          }
        end

        it { is_expected.to contain_class('postfix::augeas') }

        it {
          is_expected.to contain_augeas('Postfix transport - foo').with(
            incl: '/tmp/transport',
            lens: 'Postfix_Transport.lns',
            changes: [
              "set pattern[. = 'foo'] 'foo'",
              "rm pattern[. = 'foo']/transport",
              "rm pattern[. = 'foo']/host",
              "rm pattern[. = 'foo']/port",
              "set pattern[. = 'foo']/nexthop ':[baz]'",
            ]
          )
        }
      end

      context 'when overriding default values with [host]:port' do
        let(:params) do
          {
            destination: 'bar',
            nexthop: '[baz]:1234',
            file: '/tmp/transport',
            ensure: 'present',
          }
        end

        it { is_expected.to contain_class('postfix::augeas') }

        it {
          is_expected.to contain_augeas('Postfix transport - foo').with(
            incl: '/tmp/transport',
            lens: 'Postfix_Transport.lns',
            changes: [
              "set pattern[. = 'foo'] 'foo'",
              "rm pattern[. = 'foo']/transport",
              "rm pattern[. = 'foo']/nexthop",
              "set pattern[. = 'foo']/host '[baz]'",
              "set pattern[. = 'foo']/port '1234'",
            ]
          )
        }
      end

      context 'when overriding default values with :[host]:port' do
        let(:params) do
          {
            destination: 'bar',
            nexthop: ':[baz]:1234',
            file: '/tmp/transport',
            ensure: 'present',
          }
        end

        it { is_expected.to contain_class('postfix::augeas') }

        it {
          is_expected.to contain_augeas('Postfix transport - foo').with(
            incl: '/tmp/transport',
            lens: 'Postfix_Transport.lns',
            changes: [
              "set pattern[. = 'foo'] 'foo'",
              "rm pattern[. = 'foo']/transport",
              "rm pattern[. = 'foo']/nexthop",
              "set pattern[. = 'foo']/host ':[baz]'",
              "set pattern[. = 'foo']/port '1234'",
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
          is_expected.to contain_augeas('Postfix transport - foo').with(
            incl: postfix_transport_path,
            lens: 'Postfix_Transport.lns',
            changes: [
              "rm pattern[. = 'foo']",
            ]
          )
        }
      end
    end
  end
end
