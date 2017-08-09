require 'spec_helper'

describe 'postfix::map' do
  let (:title) { 'foo' }

  let :pre_condition do
    "class { '::postfix': }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'when passing wrong type for ensure' do
        let (:params) { {
          :ensure => ['present'],
        } }
        it 'should fail' do
          expect {
            is_expected.to contain_file('postfix map foo')
          }.to raise_error
        end
      end

      context 'when passing wrong value for ensure' do
        let (:params) { {
          :ensure => 'running',
        } }
        it 'should fail' do
          expect {
            is_expected.to contain_file('postfix map foo')
          }.to raise_error(Puppet::Error, /got 'running'/)
        end
      end

      context 'when passing both source and content' do
        let (:params) { {
          :source  => '/tmp/bar',
          :content => 'bar',
        } }

        it 'should fail' do
          expect {
            is_expected.to contain_file('postfix map foo')
          }.to raise_error(Puppet::Error, /You must provide either 'source' or 'content'/)
        end
      end

      context 'when passing source' do
        let (:params) { {
          :source  => '/tmp/bar',
        } }

        it { is_expected.to contain_file('postfix map foo').with(
          :ensure => 'present',
          :source => '/tmp/bar'
        ).without(:content)
        }
        it { is_expected.to contain_file('postfix map foo.db').with_ensure('present') }
        it { is_expected.to contain_exec('generate foo.db') }
      end

      context 'when passing content' do
        let (:params) { {
          :content => 'bar',
        } }

        it { is_expected.to contain_file('postfix map foo').with(
          :ensure  => 'present',
          :content => 'bar'
        ).without(:source)
        }
        it { is_expected.to contain_file('postfix map foo.db').with_ensure('present') }
        it { is_expected.to contain_exec('generate foo.db') }
      end

      context 'when not passing source or content' do
        it { is_expected.to contain_file('postfix map foo').with(
          :ensure  => 'present'
        ).without(:source).without(:content)
        }
        it { is_expected.to contain_file('postfix map foo.db').with_ensure('present') }
        it { is_expected.to contain_exec('generate foo.db') }
      end

      context 'when ensuring absence' do
        let (:params) { {
          :ensure => 'absent',
        } }

        it { is_expected.to contain_file('postfix map foo').with_ensure('absent') }
        it { is_expected.to contain_file('postfix map foo').without_notify }
        it { is_expected.to contain_file('postfix map foo.db').with_ensure('absent') }
        it { is_expected.to contain_exec('generate foo.db') }
      end

      context 'when using pcre type' do
        let (:params) { {
          :type => 'pcre',
        } }

        it { is_expected.to contain_file('postfix map foo').with_ensure('present') }
        it { is_expected.not_to contain_file('postfix map foo.db') }
      end

      context 'when using cidr type' do
        let (:params) { {
          :type => 'cidr',
        } }

        it { is_expected.to contain_file('postfix map foo').with_ensure('present') }
        it { is_expected.not_to contain_file('postfix map foo.db') }
      end
    end
  end
end
