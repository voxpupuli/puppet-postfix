require 'spec_helper'

describe 'postfix::virtual' do
  let (:title) { 'foo' }

  let :pre_condition do
    "class { '::augeas': }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :augeasversion => '1.2.0',
          :puppetversion => Puppet.version,
        })
      end

      context 'when not sending destination' do
        it 'should fail' do
          expect {
            is_expected.to contain_augeas('Postfix virtual - foo')
          }.to raise_error(Puppet::Error, /destination/)
        end
      end

      context 'when sending wrong type for destination' do
        let (:params) { {
          :destination => ['bar'],
        } }

        it 'should fail' do
          expect {
            is_expected.to contain_augeas('Postfix virtual - foo')
          }.to raise_error
        end
      end

      context 'when sending wrong type for file' do
        let (:params) { {
          :destination => 'bar',
          :file        => ['baz'],
        } }

        it 'should fail' do
          expect {
            is_expected.to contain_augeas('Postfix virtual - foo')
          }.to raise_error
        end
      end

      context 'when sending wrong value for file' do
        let (:params) { {
          :destination => 'bar',
          :file        => 'baz',
        } }

        it 'should fail' do
          expect {
            is_expected.to contain_augeas('Postfix virtual - foo')
          }.to raise_error(Puppet::Error, /got 'baz'/)
        end
      end

      context 'when sending wrong type for ensure' do
        let (:params) { {
          :destination => 'bar',
          :ensure      => ['baz'],
        } }

        it 'should fail' do
          expect {
            is_expected.to contain_augeas('Postfix virtual - foo')
          }.to raise_error
        end
      end

      context 'when sending wrong value for ensure' do
        let (:params) { {
          :destination => 'bar',
          :ensure      => 'running',
        } }

        it 'should fail' do
          expect {
            is_expected.to contain_augeas('Postfix virtual - foo')
          }.to raise_error(Puppet::Error, /got 'running'/)
        end
      end

      context 'when using default values' do
        let (:params) { {
          :destination => 'bar',
        } }

        it { is_expected.to contain_class('postfix::augeas') }
        it { is_expected.to contain_augeas('Postfix virtual - foo').with(
          :incl    => '/etc/postfix/virtual',
          :lens    => 'Postfix_Virtual.lns',
          :changes => [
            "set pattern[. = 'foo'] 'foo'",
            "set pattern[. = 'foo']/destination 'bar'",
          ])
        }
      end

      context 'when overriding default values' do
        let (:params) { {
          :destination => 'bar',
          :file        => '/tmp/virtual',
          :ensure      => 'present',
        } }

        it { is_expected.to contain_class('postfix::augeas') }
        it { is_expected.to contain_augeas('Postfix virtual - foo').with(
          :incl    => '/tmp/virtual',
          :lens    => 'Postfix_Virtual.lns',
          :changes => [
            "set pattern[. = 'foo'] 'foo'",
            "set pattern[. = 'foo']/destination 'bar'",
          ])
        }
      end

      context 'when ensuring absence' do
        let (:params) { {
          :destination => 'bar',
          :ensure      => 'absent',
        } }

        it { is_expected.to contain_class('postfix::augeas') }
        it { is_expected.to contain_augeas('Postfix virtual - foo').with(
          :incl    => '/etc/postfix/virtual',
          :lens    => 'Postfix_Virtual.lns',
          :changes => [
            "rm pattern[. = 'foo']",
          ])
        }
      end
    end
  end
end
