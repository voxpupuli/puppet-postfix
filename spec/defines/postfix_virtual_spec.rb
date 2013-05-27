require 'spec_helper'

describe 'postfix::virtual' do
  let (:title) { 'foo' }
  let (:facts) { {
    :osfamily => 'Debian',
  } }

  context 'when not sending destination' do
    it 'should fail' do
      expect {
        should contain_augeas('Postfix virtual - foo')
      }.to raise_error(Puppet::Error, /Must pass destination/)
    end
  end

  context 'when sending wrong type for destination' do
    let (:params) { {
      :destination => ['bar'],
    } }

    it 'should fail' do
      expect {
        should contain_augeas('Postfix virtual - foo')
      }.to raise_error(Puppet::Error, /\["bar"\] is not a string/)
    end
  end

  context 'when sending wrong type for file' do
    let (:params) { {
      :destination => 'bar',
      :file        => ['baz'],
    } }

    it 'should fail' do
      expect {
        should contain_augeas('Postfix virtual - foo')
      }.to raise_error(Puppet::Error, /\["baz"\] is not a string/)
    end
  end

  context 'when sending wrong value for file' do
    let (:params) { {
      :destination => 'bar',
      :file        => 'baz',
    } }

    it 'should fail' do
      expect {
        should contain_augeas('Postfix virtual - foo')
      }.to raise_error(Puppet::Error, /"baz" is not an absolute path/)
    end
  end

  context 'when sending wrong type for ensure' do
    let (:params) { {
      :destination => 'bar',
      :ensure      => ['baz'],
    } }

    it 'should fail' do
      expect {
        should contain_augeas('Postfix virtual - foo')
      }.to raise_error(Puppet::Error, /\["baz"\] is not a string/)
    end
  end

  context 'when sending wrong value for ensure' do
    let (:params) { {
      :destination => 'bar',
      :ensure      => 'running',
    } }

    it 'should fail' do
      expect {
        should contain_augeas('Postfix virtual - foo')
      }.to raise_error(Puppet::Error, /\$ensure must be either/)
    end
  end

  context 'when using default values' do
    let (:params) { {
      :destination => 'bar',
    } }

    it { should include_class('postfix::augeas') }
    it { should contain_augeas('Postfix virtual - foo').with(
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

    it { should include_class('postfix::augeas') }
    it { should contain_augeas('Postfix virtual - foo').with(
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

    it { should include_class('postfix::augeas') }
    it { should contain_augeas('Postfix virtual - foo').with(
      :incl    => '/etc/postfix/virtual',
      :lens    => 'Postfix_Virtual.lns',
      :changes => [
        "rm pattern[. = 'foo']",
      ])
    }
  end
end
