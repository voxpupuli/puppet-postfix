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

      it { should contain_postfix__config('myorigin').with_value('fqdn.example.com') }
      it { should contain_postfix__config('alias_maps').with_value('hash:/etc/aliases') }
      it { should contain_postfix__config('inet_interfaces').with_value('all') }

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

      it { should contain_postfix__config('myorigin').with_value('fqdn.example.com') }
      it { should contain_postfix__config('alias_maps').with_value('hash:/etc/aliases') }
      it { should contain_postfix__config('inet_interfaces').with_value('all') }
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
          :use_amavisd         => true,
          :use_dovecot_lda     => true,
          :use_schleuder       => true,
          :use_sympa           => true,
          :mail_user           => 'bar',
          :myorigin            => 'localhost',
          :inet_interfaces     => 'localhost2',
          :master_smtp         => "smtp      inet  n       -       -       -       -       smtpd
    -o smtpd_client_restrictions=check_client_access,hash:/etc/postfix/access,reject",
          :master_smtps        => 'smtps     inet  n       -       -       -       -       smtpd',
          :master_submission   => 'submission inet n       -       -       -       -       smtpd',
        } }

        it { should contain_package('postfix') }
        it { should contain_package('mailx') }

        it { should contain_file('/etc/mailname').without('seltype').with_content("fqdn.example.com\n") }
        it { should contain_file('/etc/aliases').without('seltype').with_content("# file managed by puppet\n") }
        it { should contain_exec('newaliases').with_refreshonly('true') }
        it {
          should contain_file('/etc/postfix/master.cf').without('seltype').with_content(
            /smtp      inet  n       -       -       -       -       smtpd/
          ).with_content(
            /amavis unix/
          ).with_content(
            /dovecot.*\n.* user=bar:bar /
          ).with_content(
            /schleuder/
          ).with_content(
            /sympa/
          ).with_content(
            /user=bar/
          ).with_content(
            /^smtp.*\n.*smtpd_client_restrictions=check_client_access,hash:/
          ).with_content(
            /^smtps     inet  n/
          ).with_content(
            /^submission inet n/
          )
        }
        it { should contain_file('/etc/postfix/main.cf').without('seltype') }

        it { should contain_postfix__config('myorigin').with_value('localhost') }
        it { should contain_postfix__config('alias_maps').with_value('hash:/etc/aliases') }
        it { should contain_postfix__config('inet_interfaces').with_value('localhost2') }

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
    context 'when on RedHat' do
      let (:facts) { {
        :operatingsystem => 'Debian',
        :osfamily        => 'Debian',
        :fqdn            => 'fqdn.example.com',
      } }
      context 'when specifying inet_interfaces' do
        let (:params) { {
          :inet_interfaces => 'localhost2'
        } }
        it 'should create a postfix::config defined type with inet_interfaces specified properly' do
          should contain_postfix__config('inet_interfaces').with_value('localhost2')
        end
      end
      context 'when enabling ldap' do
        it 'should do stuff' do
          pending 'need to write this still'
        end
      end
      context 'when a custom mail_user is specified' do
        let (:params) { {
          :mail_user => 'bar'
        } }
        it 'should adjust the content of /etc/postfix/master.cf specifying the user' do
          should contain_file('/etc/postfix/master.cf').without('seltype').with_content(/user=bar/)
        end
      end
      context 'when mailman is true' do
        let (:params) { {
          :mailman => true
        } }
        it 'should do stuff' do
          pending 'need to write this still'
        end
      end
      context 'when specifying a custom mastercf_source' do
        let (:params) { {
          :mastercf_source => 'testy'
        } }
        it 'should do stuff' do
          pending 'need to write this still'
        end
      end
      context 'when specifying a custom master_smtp' do
        let (:params) { {
          :master_smtp         => "smtp      inet  n       -       -       -       -       smtpd
    -o smtpd_client_restrictions=check_client_access,hash:/etc/postfix/access,reject",
        } }
        it 'should update master.cf with the specified flags to smtp' do 
          should contain_file('/etc/postfix/master.cf').without('seltype').with_content(
            /smtp      inet  n       -       -       -       -       smtpd/).with_content(
            /^smtp.*\n.*smtpd_client_restrictions=check_client_access,hash:/
          )
        end
      end
      context 'when specifying a custom master_smtps' do
        let (:params) { {
          :master_smtps        => 'smtps     inet  n       -       -       -       -       smtpd'
        } }
        it 'should update master.cf with the specified flags to smtps' do
          should contain_file('/etc/postfix/master.cf').with_content(/^smtps     inet  n/)
        end
      end
      context 'when mta is enabled' do
        let (:params) { { :mta => true, :mydestination => '1.2.3.4', :relayhost => '2.3.4.5' } }
        it 'should configure postfix as a minimal MTA, delivering mail to the mydestination param' do
          should contain_postfix__config('mydestination').with_value('1.2.3.4')
          should contain_postfix__config('mynetworks').with_value('127.0.0.0/8')
          should contain_postfix__config('relayhost').with_value('2.3.4.5')
          should contain_postfix__config('virtual_alias_maps').with_value('hash:/etc/postfix/virtual')
          should contain_postfix__config('transport_maps').with_value('hash:/etc/postfix/transport')
        end
        it { should include_class('postfix::mta') }
        context 'and satellite is also enabled' do
          let (:params) { { :mta => true, :satellite => true, :mydestination => '1.2.3.4', :relayhost => '2.3.4.5' } }
          it 'should fail' do
            expect {subject}.to raise_error(Puppet::Error, /Please disable one/)
          end
        end
      end
      context 'when specifying mydesitination' do
        it 'should do stuff' do
          pending 'need to write this still'
        end
      end
      context 'when specifying mynetworks' do
        it 'should do stuff' do
          pending 'need to write this still'
        end
      end
      context 'when specifying myorigin' do
        let (:params) { { :myorigin => 'localhost'} }
        it 'should create a postfix::config defined type with myorigin specified properly' do
          should contain_postfix__config('myorigin').with_value('localhost')
        end
      end
      context 'when specifying relayhost' do
        it 'should do stuff' do
          pending 'need to write this still'
        end
      end
      context 'when specifying a root_mail_recipient' do
        let (:params) { { :root_mail_recipient => 'foo'} }
        it 'should contain a Mailalias resource directing roots mail to the required user' do
          should contain_mailalias('root').with_recipient('foo')
        end
      end
      context 'when specifying satellite' do
        let (:params) { { :satellite => true, :mydestination => '1.2.3.4', :relayhost => '2.3.4.5' } }
        it 'should configure all local email to be forwarded to $root_mail_recipient delivered through $relayhost' do
          should contain_postfix__config('mydestination').with_value('1.2.3.4')
          should contain_postfix__config('mynetworks').with_value('127.0.0.0/8')
          should contain_postfix__config('relayhost').with_value('2.3.4.5')
          should contain_postfix__config('virtual_alias_maps').with_value('hash:/etc/postfix/virtual')
          should contain_postfix__config('transport_maps').with_value('hash:/etc/postfix/transport')
        end
        context 'and mta is also enabled' do
          let (:params) { { :mta => true, :satellite => true, :mydestination => '1.2.3.4', :relayhost => '2.3.4.5' } }
          it 'should fail' do
            expect {subject}.to raise_error(Puppet::Error, /Please disable one/)
          end
        end
      end
      context 'when specifying smtp_listen' do
        let (:params) { { :smtp_listen => 'all' } }
        it 'should do stuff' do
          pending 'need to write this still'
        end
      end
      context 'when use_amavisd is true' do
        let (:params) { { :use_amavisd => true } }
        it 'should update master.cf with the specified flags to amavis' do
          should contain_file('/etc/postfix/master.cf').with_content(/amavis unix/)
        end
      end
      context 'when use_dovecot_lda is true' do
        let (:params) { { :use_dovecot_lda => true } }
        it 'should update master.cf with the specified flags to dovecot' do
          should contain_file('/etc/postfix/master.cf').with_content(/dovecot.*\n.* user=vmail:vmail /)
        end
      end
      context 'when use_schleuder is true' do
        let (:params) { { :use_schleuder => true } }
        it 'should update master.cf with the specified flags to schleuder' do
          should contain_file('/etc/postfix/master.cf').with_content(/schleuder/)
        end
      end
      context 'when use_sympa is true' do
        let (:params) { { :use_sympa => true } }
        it 'should update master.cf to include sympa' do
          should contain_file('/etc/postfix/master.cf').with_content(/sympa/)
        end
      end
    end
  end
end
