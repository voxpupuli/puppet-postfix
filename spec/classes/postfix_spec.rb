require 'spec_helper'

describe 'postfix' do
  context 'when using defaults' do
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
      it { should contain_exec('newaliases').with_refreshonly('true') }
      it { should contain_file('/etc/postfix/master.cf') }
      it { should contain_file('/etc/postfix/main.cf' ) }

      it { should contain_postfix__config('myorigin') }
      it { should contain_postfix__config('alias_maps') }
      it { should contain_postfix__config('inet_interfaces') }

      it { should contain_mailalias('root') }

      it {
        should contain_service('postfix').with(
          :ensure    => 'running',
          :enable    => 'true',
          :hasstatus => 'true',
          :restart   => '/etc/init.d/postfix reload'
      ) }
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
      it { should contain_exec('newaliases').with_refreshonly('true') }
      it { should contain_file('/etc/postfix/master.cf') }
      it { should contain_file('/etc/postfix/main.cf' ) }

      it { should contain_postfix__config('myorigin') }
      it { should contain_postfix__config('alias_maps') }
      it { should contain_postfix__config('inet_interfaces') }
      it { should contain_postfix__config('sendmail_path') }
      it { should contain_postfix__config('newaliases_path') }
      it { should contain_postfix__config('mailq_path') }

      it { should contain_mailalias('root') }

      it {
        should contain_service('postfix').with(
          :ensure    => 'running',
          :enable    => 'true',
          :hasstatus => 'true',
          :restart   => '/etc/init.d/postfix reload'
      ) }
    end
  end
end
