require 'spec_helper'

describe 'postfix' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :augeasversion => '1.2.0',
          :puppetversion => Puppet.version,
        })
      end

      context 'when using defaults' do
        it { is_expected.to contain_package('postfix') }
        it { is_expected.to contain_package('mailx') }
        it { is_expected.to contain_exec('newaliases').with_refreshonly('true') }
        it { is_expected.to contain_postfix__config('myorigin').with_value('foo.example.com') }
        it { is_expected.to contain_postfix__config('alias_maps').with_value('hash:/etc/aliases') }
        it { is_expected.to contain_postfix__config('inet_interfaces').with_value('all') }
        it { is_expected.to contain_postfix__config('inet_protocols').with_value('all') }
        it { is_expected.to contain_mailalias('root').with_recipient('nobody') }

        case facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_file('/etc/mailname').without('seltype').with_content("foo.example.com\n") }
          it { is_expected.to contain_file('/etc/aliases').without('seltype').with_content("# file managed by puppet\n") }
          it { is_expected.to contain_file('/etc/postfix/master.cf').without('seltype') }
          it { is_expected.to contain_file('/etc/postfix/main.cf').without('seltype') }

          it {
            is_expected.to contain_service('postfix').with(
              :ensure    => 'running',
              :enable    => 'true',
              :hasstatus => 'true',
              :restart   => '/etc/init.d/postfix reload'
            ) }
        else
          it { is_expected.to contain_file('/etc/mailname').with_seltype('postfix_etc_t').with_content("foo.example.com\n") }
          it { is_expected.to contain_file('/etc/postfix/master.cf').with_seltype('postfix_etc_t') }
          it { is_expected.to contain_file('/etc/postfix/main.cf').with_seltype('postfix_etc_t') }

          it { is_expected.to contain_postfix__config('sendmail_path') }
          it { is_expected.to contain_postfix__config('newaliases_path') }
          it { is_expected.to contain_postfix__config('mailq_path') }

          case facts[:operatingsystemmajrelease]
          when '7'
            it { is_expected.to contain_file('/etc/aliases').with_seltype('etc_aliases_t').with_content("# file managed by puppet\n") }
            it {
              is_expected.to contain_service('postfix').with(
                :ensure    => 'running',
                :enable    => 'true',
                :hasstatus => 'true',
                :restart   => '/bin/systemctl reload postfix'
              ) }
          when '6'
            it { is_expected.to contain_file('/etc/aliases').with_seltype('etc_aliases_t').with_content("# file managed by puppet\n") }
            it {
              is_expected.to contain_service('postfix').with(
                :ensure    => 'running',
                :enable    => 'true',
                :hasstatus => 'true',
                :restart   => '/etc/init.d/postfix reload'
              ) }
          else
            it { is_expected.to contain_file('/etc/aliases').with_seltype('postfix_etc_t').with_content("# file managed by puppet\n") }
            it {
              is_expected.to contain_service('postfix').with(
                :ensure    => 'running',
                :enable    => 'true',
                :hasstatus => 'true',
                :restart   => '/etc/init.d/postfix reload'
              ) }
          end
        end
      end

      context 'when setting parameters' do
        case facts[:osfamily]
        when 'Debian'
          context "when setting smtp_listen to 'all'" do
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

            it { is_expected.to contain_package('postfix') }
            it { is_expected.to contain_package('mailx') }

            it { is_expected.to contain_file('/etc/mailname').without('seltype').with_content("foo.example.com\n") }
            it { is_expected.to contain_file('/etc/aliases').without('seltype').with_content("# file managed by puppet\n") }
            it { is_expected.to contain_exec('newaliases').with_refreshonly('true') }
            it {
              is_expected.to contain_file('/etc/postfix/master.cf').without('seltype').with_content(
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
            it { is_expected.to contain_file('/etc/postfix/main.cf').without('seltype') }

            it { is_expected.to contain_postfix__config('myorigin').with_value('localhost') }
            it { is_expected.to contain_postfix__config('alias_maps').with_value('hash:/etc/aliases') }
            it { is_expected.to contain_postfix__config('inet_interfaces').with_value('localhost2') }

            it { is_expected.to contain_mailalias('root').with_recipient('foo') }

            it {
              is_expected.to contain_service('postfix').with(
                :ensure    => 'running',
                :enable    => 'true',
                :hasstatus => 'true',
                :restart   => '/etc/init.d/postfix reload'
              ) }
          end
        else
          context 'when specifying inet_interfaces' do
            let (:params) { {
              :inet_interfaces => 'localhost2'
            } }
            it 'should create a postfix::config defined type with inet_interfaces specified properly' do
              is_expected.to contain_postfix__config('inet_interfaces').with_value('localhost2')
            end
          end
          context 'when enabling ldap' do
            it 'should do stuff' do
              skip 'need to write this still'
            end
          end
          context 'when a custom mail_user is specified' do
            let (:params) { {
              :mail_user => 'bar'
            } }
            it 'should adjust the content of /etc/postfix/master.cf specifying the user' do
              is_expected.to contain_file('/etc/postfix/master.cf').with_seltype('postfix_etc_t').with_content(/user=bar/)
            end
          end
          context 'when mailman is true' do
            let (:params) { {
              :mailman => true
            } }
            it 'should do stuff' do
              skip 'need to write this still'
            end
          end
          context 'when specifying a custom mastercf_source' do
            let (:params) { {
              :mastercf_source => 'testy'
            } }
            it 'should do stuff' do
              skip 'need to write this still'
            end
          end
          context 'when specifying a custom master_smtp' do
            let (:params) { {
              :master_smtp         => "smtp      inet  n       -       -       -       -       smtpd
    -o smtpd_client_restrictions=check_client_access,hash:/etc/postfix/access,reject",
            } }
            it 'should update master.cf with the specified flags to smtp' do
              is_expected.to contain_file('/etc/postfix/master.cf').with_seltype('postfix_etc_t').with_content(
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
              is_expected.to contain_file('/etc/postfix/master.cf').with_content(/^smtps     inet  n/)
            end
          end
          context 'when mta is enabled' do
            let (:params) { { :mta => true, :mydestination => '1.2.3.4', :relayhost => '2.3.4.5' } }
            it 'should configure postfix as a minimal MTA, delivering mail to the mydestination param' do
              is_expected.to contain_postfix__config('mydestination').with_value('1.2.3.4')
              is_expected.to contain_postfix__config('mynetworks').with_value('127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128')
              is_expected.to contain_postfix__config('relayhost').with_value('2.3.4.5')
              is_expected.to contain_postfix__config('virtual_alias_maps').with_value('hash:/etc/postfix/virtual')
              is_expected.to contain_postfix__config('transport_maps').with_value('hash:/etc/postfix/transport')
            end
            it { is_expected.to contain_class('postfix::mta') }
            context 'and satellite is also enabled' do
              let (:params) { { :mta => true, :satellite => true, :mydestination => '1.2.3.4', :relayhost => '2.3.4.5' } }
              it 'should fail' do
                expect { should compile }.to raise_error(/Please disable one/)
              end
            end
          end
          context 'when specifying mydesitination' do
            it 'should do stuff' do
              skip 'need to write this still'
            end
          end
          context 'when specifying mynetworks' do
            it 'should do stuff' do
              skip 'need to write this still'
            end
          end
          context 'when specifying myorigin' do
            let (:params) { { :myorigin => 'localhost'} }
            it 'should create a postfix::config defined type with myorigin specified properly' do
              is_expected.to contain_postfix__config('myorigin').with_value('localhost')
            end
          end
          context 'when specifying relayhost' do
            it 'should do stuff' do
              skip 'need to write this still'
            end
          end
          context 'when specifying a root_mail_recipient' do
            let (:params) { { :root_mail_recipient => 'foo'} }
            it 'should contain a Mailalias resource directing roots mail to the required user' do
              is_expected.to contain_mailalias('root').with_recipient('foo')
            end
          end
          context 'when specifying satellite' do
            let (:params) { { :satellite => true, :mydestination => '1.2.3.4', :relayhost => '2.3.4.5' } }
            let :pre_condition do
              "class { 'augeas': }"
            end
            it 'should configure all local email to be forwarded to $root_mail_recipient delivered through $relayhost' do
              is_expected.to contain_postfix__config('mydestination').with_value('1.2.3.4')
              is_expected.to contain_postfix__config('mynetworks').with_value('127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128')
              is_expected.to contain_postfix__config('relayhost').with_value('2.3.4.5')
              is_expected.to contain_postfix__config('virtual_alias_maps').with_value('hash:/etc/postfix/virtual')
              is_expected.to contain_postfix__config('transport_maps').with_value('hash:/etc/postfix/transport')
            end
            context 'and mta is also enabled' do
              let (:params) { { :mta => true, :satellite => true, :mydestination => '1.2.3.4', :relayhost => '2.3.4.5' } }
              it 'should fail' do
                expect { should compile }.to raise_error(/Please disable one/)
              end
            end
          end
          context 'when specifying smtp_listen' do
            let (:params) { { :smtp_listen => 'all' } }
            it 'should do stuff' do
              skip 'need to write this still'
            end
          end
          context 'when use_amavisd is true' do
            let (:params) { { :use_amavisd => true } }
            it 'should update master.cf with the specified flags to amavis' do
              is_expected.to contain_file('/etc/postfix/master.cf').with_content(/amavis unix/)
            end
          end
          context 'when use_dovecot_lda is true' do
            let (:params) { { :use_dovecot_lda => true } }
            it 'should update master.cf with the specified flags to dovecot' do
              is_expected.to contain_file('/etc/postfix/master.cf').with_content(/dovecot.*\n.* user=vmail:vmail /)
            end
          end
          context 'when use_schleuder is true' do
            let (:params) { { :use_schleuder => true } }
            it 'should update master.cf with the specified flags to schleuder' do
              is_expected.to contain_file('/etc/postfix/master.cf').with_content(/schleuder/)
            end
          end
          context 'when use_sympa is true' do
            let (:params) { { :use_sympa => true } }
            it 'should update master.cf to include sympa' do
              is_expected.to contain_file('/etc/postfix/master.cf').with_content(/sympa/)
            end
          end
          context 'when manage_root_alias is false' do
            let(:params) { { :manage_root_alias => false } }
            it 'should not manage root mailalias' do
              is_expected.not_to contain_mailalias('root')
            end
          end
          context 'when manage_mailx is false' do
            let(:params) { { :manage_mailx => false } }
            it 'should not have mailx package' do
              is_expected.not_to contain_package('mailx')
            end
          end
        end
      end
    end
  end
end
