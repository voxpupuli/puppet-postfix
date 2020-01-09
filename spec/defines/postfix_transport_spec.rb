require 'spec_helper'

describe 'postfix::transport' do
  let(:title) { 'foo' }

  let :pre_condition do
    "class { '::augeas': }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(augeasversion: '1.2.0',
                    puppetversion: Puppet.version)
      end

      context 'when sending wrong type for destination' do
        let(:params) do
          {
            destination: ['bar'],
          }
        end

        it 'fails' do
          expect {
            is_expected.to contain_augeas('Postfix transport - foo')
          }.to raise_error
        end
      end

      context 'when sending wrong type for nexthop' do
        let(:params) do
          {
            destination: 'bar',
            nexthop: ['baz'],
          }
        end

        it 'fails' do
          expect {
            is_expected.to contain_augeas('Postfix transport - foo')
          }.to raise_error
        end
      end

      context 'when sending wrong type for file' do
        let(:params) do
          {
            destination: 'bar',
            file: ['baz'],
          }
        end

        it 'fails' do
          expect {
            is_expected.to contain_augeas('Postfix transport - foo')
          }.to raise_error
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
          expect {
            is_expected.to contain_augeas('Postfix transport - foo')
          }.to raise_error(Puppet::Error, %r{, got })
        end
      end

      context 'when sending wrong type for ensure' do
        let(:params) do
          {
            destination: 'bar',
            ensure: ['baz'],
          }
        end

        it 'fails' do
          expect {
            is_expected.to contain_augeas('Postfix transport - foo')
          }.to raise_error
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
          expect {
            is_expected.to contain_augeas('Postfix transport - foo')
          }.to raise_error(Puppet::Error, %r{got 'running'})
        end
      end

      context 'when using default values' do
        it { is_expected.to contain_class('postfix::augeas') }
        it {
          is_expected.to contain_augeas('Postfix transport - foo').with(
            incl: '/etc/postfix/transport',
            lens: 'Postfix_Transport.lns',
            changes: [
              "set pattern[. = 'foo'] 'foo'",
              "clear pattern[. = 'foo']/transport",
              "clear pattern[. = 'foo']/nexthop",
            ],
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
              "set pattern[. = 'foo']/nexthop 'baz'",
            ],
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
            incl: '/etc/postfix/transport',
            lens: 'Postfix_Transport.lns',
            changes: [
              "rm pattern[. = 'foo']",
            ],
          )
        }
      end
    end
  end
end
