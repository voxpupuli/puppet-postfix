require 'spec_helper'

describe 'postfix::passwordmap' do
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

      context 'when sending wrong value for file' do
        let (:params) { {
          :username => 'bar',
          :file     => 'baz',
        } }

        it 'should fail' do
          expect {
            is_expected.to contain_augeas('Postfix passwordmap - foo')
          }.to raise_error(Puppet::Error, /"baz" is not an absolute path/)
        end
      end

      context 'when sending wrong type for username' do
        let (:params) { {
          :file     => '/tmp/passwd',
          :username => ['bar'],
        } }

        it 'should fail' do
          expect {
            is_expected.to contain_augeas('Postfix passwordmap - foo')
          }.to raise_error(Puppet::Error, /Username must be a none empty string/)
        end
      end

      context 'when sending wrong type for password' do
        let (:params) { {
          :file     => '/tmp/passwd',
          :username => 'bar',
          :password => ['baz'],
        } }

        it 'should fail' do
          expect {
            is_expected.to contain_augeas('Postfix passwordmap - foo')
          }.to raise_error(Puppet::Error, /\["baz"\] is not a string/)
        end
      end

      context 'when sending wrong type for ensure' do
        let (:params) { {
          :file     => '/tmp/passwd',
          :username => 'bar',
          :ensure   => ['baz'],
        } }

        it 'should fail' do
          expect {
            is_expected.to contain_augeas('Postfix passwordmap - foo')
          }.to raise_error(Puppet::Error, /\["baz"\] is not a string/)
        end
      end

      context 'when sending wrong value for ensure' do
        let (:params) { {
          :file     => '/tmp/passwd',
          :username => 'bar',
          :ensure   => 'running',
        } }

        it 'should fail' do
          expect {
            is_expected.to contain_augeas('Postfix passwordmap - foo')
          }.to raise_error(Puppet::Error, /\$ensure must be either/)
        end
      end

      context 'when using default values' do
        it 'should fail' do
          expect { 
            is_expected.to contain_augeas('Postfix passwordmap - foo')
          }.to raise_error(Puppet::Error, /"" is not an absolute path/)
        end
      end

      context 'when overriding default values' do
        let (:params) { {
          :file        => '/tmp/passwd',
          :username    => 'bar',
          :password    => 'baz',
          :ensure      => 'present',
        } }

        it { is_expected.to contain_class('postfix::augeas') }
        it { is_expected.to contain_augeas('Postfix passwordmap - foo').with(
          :incl    => '/tmp/passwd',
          :lens    => 'Postfix_Passwordmap.lns',
          :changes => [
            "set pattern[. = 'foo'] 'foo'",
            "set pattern[. = 'foo']/username 'bar'",
            "set pattern[. = 'foo']/password 'baz'",
          ])
        }
      end

      context 'when overriding default values no password' do
        let (:params) { {
          :file        => '/tmp/passwd',
          :username    => 'bar',
          :ensure      => 'present',
        } }

        it { is_expected.to contain_class('postfix::augeas') }
        it { is_expected.to contain_augeas('Postfix passwordmap - foo').with(
          :incl    => '/tmp/passwd',
          :lens    => 'Postfix_Passwordmap.lns',
          :changes => [
            "set pattern[. = 'foo'] 'foo'",
            "set pattern[. = 'foo']/username 'bar'",
            "clear pattern[. = 'foo']/password",
          ])
        }
      end

      context 'when ensuring absence' do
        let (:params) { {
          :file     => '/tmp/passwd',
          :username => 'bar',
          :ensure   => 'absent',
        } }

        it { is_expected.to contain_class('postfix::augeas') }
        it { is_expected.to contain_augeas('Postfix passwordmap - foo').with(
          :incl    => '/tmp/passwd',
          :lens    => 'Postfix_Passwordmap.lns',
          :changes => [
            "rm pattern[. = 'foo']",
          ])
        }
      end
    end
  end
end
