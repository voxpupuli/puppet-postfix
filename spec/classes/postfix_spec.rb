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

      it { should contain_file('/etc/mailname').without('seltype').with_content("fqdn.example.com\n") }
      it { should contain_file('/etc/aliases').without('seltype').with_content("# file managed by puppet\n") }
      it { should contain_exec('newaliases').with_refreshonly('true') }
      it { should contain_file('/etc/postfix/master.cf').without('seltype') }
      it { should contain_file('/etc/postfix/main.cf').without('seltype') }

      it { should contain_postfix__config('myorigin') }
      it { should contain_postfix__config('alias_maps') }
      it { should contain_postfix__config('inet_interfaces') }

      it { should contain_mailalias('root').with_recipient('nobody') }

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

      it { should contain_file('/etc/mailname').without('seltype').with_content("fqdn.example.com\n") }
      it { should contain_file('/etc/aliases').without('seltype').with_content("# file managed by puppet\n") }
      it { should contain_exec('newaliases').with_refreshonly('true') }
      it { should contain_file('/etc/postfix/master.cf').without('seltype') }
      it { should contain_file('/etc/postfix/main.cf').without('seltype') }

      it { should contain_postfix__config('myorigin') }
      it { should contain_postfix__config('alias_maps') }
      it { should contain_postfix__config('inet_interfaces') }
      it { should contain_postfix__config('sendmail_path') }
      it { should contain_postfix__config('newaliases_path') }
      it { should contain_postfix__config('mailq_path') }

      it { should contain_mailalias('root').with_recipient('nobody') }

      it {
        should contain_service('postfix').with(
          :ensure    => 'running',
          :enable    => 'true',
          :hasstatus => 'true',
          :restart   => '/etc/init.d/postfix reload'
      ) }
    end
  end

  context 'when setting parameters' do
    context 'when on Debian' do
      context "when setting smtp_listen to 'all'" do
        let (:facts) { {
          :operatingsystem => 'Debian',
          :osfamily        => 'Debian',
          :fqdn            => 'fqdn.example.com',
        } }

        let (:params) { {
          :smtp_listen         => 'all',
          :root_mail_recipient => 'foo',
          :use_amavisd         => 'yes',
          :use_dovecot_lda     => 'yes',
          :use_schleuder       => 'yes',
          :use_sympa           => 'yes',
          :mail_user           => 'bar',
          :myorigin            => 'localhost',
          :inet_interfaces     => 'localhost2',
        } }

        it { should contain_package('postfix') }
        it { should contain_package('mailx') }

        it { should contain_file('/etc/mailname').without('seltype').with_content("fqdn.example.com\n") }
        it { should contain_file('/etc/aliases').without('seltype').with_content("# file managed by puppet\n") }
        it { should contain_exec('newaliases').with_refreshonly('true') }
        it {
          should contain_file('/etc/postfix/master.cf').without('seltype').with_content(
            /smtp      inet  n       -       -       -       -       smtpd/
        ) }
        it { should contain_file('/etc/postfix/main.cf').without('seltype') }

        it { should contain_postfix__config('myorigin') }
        it { should contain_postfix__config('alias_maps') }
        it { should contain_postfix__config('inet_interfaces') }

        it { should contain_mailalias('root').with_recipient('foo') }

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
end
