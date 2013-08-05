require 'spec_helper'

describe 'postfix::hash' do
  let (:title) { '/tmp/foo' }
  let (:facts) { {
    :osfamily => 'Debian',
    :needs_postfix_class => true,
  } }

  context 'when passing wrong type for ensure' do
    let (:params) { {
      :ensure => ['present'],
    } }
    it 'should fail' do
      expect {
        should contain_file('/tmp/foo')
      }.to raise_error(Puppet::Error, /\["present"\] is not a string/)
    end
  end

  context 'when passing wrong value for ensure' do
    let (:params) { {
      :ensure => 'running',
    } }
    it 'should fail' do
      expect {
        should contain_file('/tmp/foo')
      }.to raise_error(Puppet::Error, /must be either 'present' or 'absent'/)
    end
  end

  context 'when passing wrong value for title' do
    let (:title) { 'foo' }
    it 'should fail' do
      expect {
        should contain_file('/tmp/foo')
      }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
    end
  end

  context 'when passing both source and content' do
    let (:params) { {
      :source  => '/tmp/bar',
      :content => 'bar',
    } }

    it 'should fail' do
      expect {
        should contain_file('/tmp/foo')
      }.to raise_error(Puppet::Error, /You must provide either 'source' or 'content'/)
    end
  end

  context 'when passing source' do
    let (:params) { {
      :source  => '/tmp/bar',
    } }

    it { should contain_file('/tmp/foo').with(
        :ensure => 'present',
        :source => '/tmp/bar'
      ).without(:content)
    }
    it { should contain_file('/tmp/foo.db').with_ensure('present') }
    it { should contain_exec('generate /tmp/foo.db') }
  end

  context 'when passing content' do
    let (:params) { {
      :content => 'bar',
    } }

    it { should contain_file('/tmp/foo').with(
        :ensure  => 'present',
        :content => 'bar'
      ).without(:source)
    }
    it { should contain_file('/tmp/foo.db').with_ensure('present') }
    it { should contain_exec('generate /tmp/foo.db') }
  end

  context 'when not passing source or content' do
    it { should contain_file('/tmp/foo').with(
        :ensure  => 'present'
      ).without(:source).without(:content)
    }
    it { should contain_file('/tmp/foo.db').with_ensure('present') }
    it { should contain_exec('generate /tmp/foo.db') }
  end

  context 'when ensuring absence' do
    let (:params) { {
      :ensure => 'absent',
    } }

    it { should contain_file('/tmp/foo').with_ensure('absent') }
    it { should contain_file('/tmp/foo.db').with_ensure('absent') }
    it { should contain_exec('generate /tmp/foo.db') }
  end
end
