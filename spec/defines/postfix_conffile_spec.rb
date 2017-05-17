require 'spec_helper'

describe 'postfix::conffile' do
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
            is_expected.to contain_file('postfix conffile foo')
          }.to raise_error
        end
      end

      context 'when passing wrong value for ensure' do
        let (:params) { {
          :ensure => 'running',
        } }
        it 'should fail' do
          expect {
            is_expected.to contain_file('postfix conffile foo')
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
            is_expected.to contain_file('postfix conffile foo')
          }.to raise_error(Puppet::Error, /You must provide either 'source' or 'content'/)
        end
      end

      context 'when passing source' do
        let (:params) { {
          :source  => 'puppet:///modules/postfix/bar',
        } }

        it { is_expected.to contain_file('postfix conffile foo').with(
          :ensure => 'present',
          :source => 'puppet:///modules/postfix/bar'
        ).without(:content)
        }
      end

      context 'when passing content' do
        let (:params) { {
          :content => 'bar',
        } }

        it { is_expected.to contain_file('postfix conffile foo').with(
          :ensure  => 'present',
          :content => 'bar'
        ).without(:source)
        }
      end

      context 'when not passing source or content' do
        it 'should fail' do
          expect {
            is_expected.to contain_file('postfix conffile foo')
          }.to raise_error(Puppet::Error, /You must provide 'options' hash parameter if you don't provide 'source' neither 'content'/)
        end
      end

      #context 'when passing options parameter' do
        #let (:params) { {
          #:options => {
            #:server_host => 'ldap.mydomain.com',
            #:bind        => 'no',
          #},
        #} }

        #it { is_expected.to contain_file('postfix conffile foo').with(
          #:ensure => 'present',
          #:content => '#
######################################################
## File managed by puppet
## DO NOT EDITY!!!
##

#bind = no
#server_host = ldap.mydomain.com'
        #).without(:source)
        #}

      #end

      context 'when ensuring absence' do
        let (:params) { {
          :ensure => 'absent',
        } }

        it { is_expected.to contain_file('postfix conffile foo').with_ensure('absent') }
      end

      context 'when using mode' do
        let (:params) { {
          :mode => '0644',
          :content => 'bar',
        } }

        it { is_expected.to contain_file('postfix conffile foo').with(
          :mode => '0644',
          :content => 'bar'
        )
        }
      end

      context 'when using path' do
        let (:params) { {
          :path => '/tmp/foo',
          :content => 'bar',
        } }

        it { is_expected.to contain_file('postfix conffile foo').with(
          :path => '/tmp/foo',
          :content => 'bar'
        )
        }
      end
    end
  end
end
