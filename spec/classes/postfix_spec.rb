require 'spec_helper'

describe 'postfix' do
  context 'when on Debian' do
    let (:facts) { {
      :operatingsystem => 'Debian',
      :osfamily        => 'Debian',
      :fqdn            => 'fqdn.example.com',
    } }

    it { should contain_package('postfix') }
    it { should contain_package('mailx') }
    it { should contain_file('/etc/mailname').with_content("fqdn.example.com\n") }
    it { should contain_file('/etc/aliases').with_content("# file managed by puppet\n") }
  end

  context 'when on RedHat' do
    let (:facts) { {
      :operatingsystem => 'RedHat',
      :osfamily        => 'RedHat',
      :fqdn            => 'fqdn.example.com',
    } }

    it { should contain_package('postfix') }
    it { should contain_package('mailx') }
    it { should contain_file('/etc/mailname').with_content("fqdn.example.com\n") }
    it { should contain_file('/etc/aliases').with_content("# file managed by puppet\n") }
  end
end
