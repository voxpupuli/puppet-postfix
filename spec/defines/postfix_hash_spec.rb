require 'spec_helper'

describe 'postfix::hash' do
  let(:title) { '/tmp/foo' }

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
            is_expected.to contain_file('/tmp/foo')
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
            is_expected.to contain_file('/tmp/foo')
          }.to raise_error(Puppet::Error, %r{got 'running'})
        end
      end

      context 'when passing wrong value for title' do
        let(:title) { 'foo' }

        it 'fails' do
          expect {
            is_expected.to contain_file('/tmp/foo')
          }.to raise_error(Puppet::Error, %r{, got })
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
            is_expected.to contain_file('/tmp/foo')
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
          is_expected.to contain_file('postfix map /tmp/foo').with(
            ensure: 'present',
            source: '/tmp/bar',
          ).without(:content)
        }
        it { is_expected.to contain_file('postfix map /tmp/foo.db').with_ensure('present') }
        it { is_expected.to contain_exec('generate /tmp/foo.db') }
      end

      context 'when passing content' do
        let(:params) do
          {
            content: 'bar',
          }
        end

        it {
          is_expected.to contain_file('postfix map /tmp/foo').with(
            ensure: 'present',
            content: 'bar',
          ).without(:source)
        }
        it { is_expected.to contain_file('postfix map /tmp/foo.db').with_ensure('present') }
        it { is_expected.to contain_exec('generate /tmp/foo.db') }
      end

      context 'when not passing source or content' do
        it {
          is_expected.to contain_file('postfix map /tmp/foo').with(
            ensure: 'present',
          ).without(:source).without(:content)
        }
        it { is_expected.to contain_file('postfix map /tmp/foo.db').with_ensure('present') }
        it { is_expected.to contain_exec('generate /tmp/foo.db') }
      end

      context 'when ensuring absence' do
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it { is_expected.to contain_file('postfix map /tmp/foo').with_ensure('absent') }
        it { is_expected.to contain_file('postfix map /tmp/foo.db').with_ensure('absent') }
        it { is_expected.to contain_exec('generate /tmp/foo.db') }
      end
    end
  end
end
