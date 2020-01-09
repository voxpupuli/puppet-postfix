require 'spec_helper'

describe 'postfix::map' do
  let(:title) { 'foo' }

  let :pre_condition do
    "class { '::postfix': }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'when passing wrong type for ensure' do
        let(:params) do
          {
            ensure: ['present'],
          }
        end

        it 'fails' do
          expect {
            is_expected.to contain_file('postfix map foo')
          }.to raise_error
        end
      end

      context 'when passing wrong value for ensure' do
        let(:params) do
          {
            ensure: 'running',
          }
        end

        it 'fails' do
          expect {
            is_expected.to contain_file('postfix map foo')
          }.to raise_error(Puppet::Error, %r{got 'running'})
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
          expect {
            is_expected.to contain_file('postfix map foo')
          }.to raise_error(Puppet::Error, %r{You must provide either 'source' or 'content'})
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
            source: '/tmp/bar',
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
            content: 'bar',
          ).without(:source)
        }
        it { is_expected.to contain_file('postfix map foo.db').with_ensure('present') }
        it { is_expected.to contain_exec('generate foo.db') }
      end

      context 'when not passing source or content' do
        it {
          is_expected.to contain_file('postfix map foo').with(
            ensure: 'present',
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
        it { is_expected.to contain_exec('generate foo.db') }
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
    end
  end
end
