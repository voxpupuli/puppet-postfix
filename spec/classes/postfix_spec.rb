# frozen_string_literal: true

require 'spec_helper'

describe 'postfix' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:postfix_main_cf_path) do
        case facts[:osfamily]
        when 'FreeBSD' then '/usr/local/etc/postfix/main.cf'
        else '/etc/postfix/main.cf'
        end
      end
      let(:postfix_master_cf_path) do
        case facts[:osfamily]
        when 'FreeBSD' then '/usr/local/etc/postfix/master.cf'
        else '/etc/postfix/master.cf'
        end
      end
      let(:postfix_transport_path) do
        case facts[:osfamily]
        when 'FreeBSD' then '/usr/local/etc/postfix/transport'
        else '/etc/postfix/transport'
        end
      end
      let(:postfix_virtual_path) do
        case facts[:osfamily]
        when 'FreeBSD' then '/usr/local/etc/postfix/virtual'
        else '/etc/postfix/virtual'
        end
      end
      let(:postfix_path) do
        case facts[:osfamily]
        when 'FreeBSD' then '/usr/local/etc/postfix'
        else '/etc/postfix'
        end
      end

      let(:facts) do
        facts.merge(augeasversion: '1.2.0',
                    puppetversion: Puppet.version)
      end

      context 'when using defaults' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        it { is_expected.to contain_package('postfix') }
        it { is_expected.to contain_exec('newaliases').with_refreshonly('true') }
        it { is_expected.to contain_postfix__config('myorigin').with_value('foo.example.com') }
        it { is_expected.to contain_postfix__config('alias_maps').with_value('hash:/etc/aliases') }
        it { is_expected.to contain_postfix__config('inet_interfaces').with_value('all') }
        it { is_expected.to contain_postfix__config('inet_protocols').with_value('all') }
        it { is_expected.to contain_postfix__mailalias('root').with_recipient('nobody') }
        it { is_expected.to contain_mailalias('root').with_recipient('nobody') }
        it { is_expected.to contain_class('postfix::files') }
        it { is_expected.to contain_class('postfix::packages') }
        it { is_expected.to contain_class('postfix::params') }
        it { is_expected.to contain_class('postfix::service') }
        it { is_expected.to contain_exec('restart postfix after packages install') }
        it { is_expected.to contain_augeas("manage postfix 'alias_maps'").with_changes("set alias_maps 'hash:/etc/aliases'") }
        it { is_expected.to contain_augeas("manage postfix 'myorigin'").with_changes("set myorigin 'foo.example.com'") }
        it { is_expected.to contain_augeas("manage postfix 'inet_interfaces'").with_changes("set inet_interfaces 'all'") }
        it { is_expected.to contain_augeas("manage postfix 'inet_protocols'").with_changes("set inet_protocols 'all'") }

        context 'when on Debian family', if: facts[:osfamily] == 'Debian' do # rubocop:disable RSpec/MultipleMemoizedHelpers
          it { is_expected.to contain_package('mailx') }
          it { is_expected.to contain_file('/etc/mailname').without('seltype').with_content("foo.example.com\n") }
          it { is_expected.to contain_file('/etc/aliases').without('seltype').with_content("# file managed by puppet\n") }
          it { is_expected.to contain_file(postfix_master_cf_path).without('seltype') }
          it { is_expected.to contain_file(postfix_main_cf_path).without('seltype') }

          it {
            is_expected.to contain_service('postfix').with(
              ensure: 'running',
              enable: 'true',
              hasstatus: 'true',
              restart: '/etc/init.d/postfix reload'
            )
          }
        end

        context 'when on RedHat family', if: facts[:osfamily] == 'RedHat' do # rubocop:disable RSpec/MultipleMemoizedHelpers
          it { is_expected.to contain_package('mailx') }
          it { is_expected.to contain_file('/etc/mailname').with_seltype('postfix_etc_t').with_content("foo.example.com\n") }
          it { is_expected.to contain_file(postfix_master_cf_path).with_seltype('postfix_etc_t') }
          it { is_expected.to contain_file(postfix_main_cf_path).with_seltype('postfix_etc_t') }

          it { is_expected.to contain_postfix__config('sendmail_path') }
          it { is_expected.to contain_postfix__config('newaliases_path') }
          it { is_expected.to contain_postfix__config('mailq_path') }
          it { is_expected.to contain_augeas("manage postfix 'sendmail_path'") }
          it { is_expected.to contain_augeas("manage postfix 'newaliases_path'") }
          it { is_expected.to contain_augeas("manage postfix 'mailq_path'") }
          it { is_expected.to contain_alternatives('mta') }

          context 'when on release 8', if: (facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease] == '8') do # rubocop:disable RSpec/MultipleMemoizedHelpers
            it { is_expected.to contain_file('/etc/aliases').with_seltype('etc_aliases_t').with_content("# file managed by puppet\n") }

            it {
              is_expected.to contain_service('postfix').with(
                ensure: 'running',
                enable: 'true',
                hasstatus: 'true',
                restart: '/bin/systemctl reload postfix'
              )
            }
          end

          context 'when on release 7', if: (facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease] == '7') do # rubocop:disable RSpec/MultipleMemoizedHelpers
            it { is_expected.to contain_file('/etc/aliases').with_seltype('etc_aliases_t').with_content("# file managed by puppet\n") }

            it {
              is_expected.to contain_service('postfix').with(
                ensure: 'running',
                enable: 'true',
                hasstatus: 'true',
                restart: '/bin/systemctl reload postfix'
              )
            }
          end

          context 'when on release 6', if: (facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease] == '6') do # rubocop:disable RSpec/MultipleMemoizedHelpers
            it { is_expected.to contain_file('/etc/aliases').with_seltype('etc_aliases_t').with_content("# file managed by puppet\n") }

            it {
              is_expected.to contain_service('postfix').with(
                ensure: 'running',
                enable: 'true',
                hasstatus: 'true',
                restart: '/etc/init.d/postfix reload'
              )
            }
          end
        end

        context 'when on Fedora', if: facts[:operatingsystem] == 'Fedora' do # rubocop:disable RSpec/MultipleMemoizedHelpers
          it { is_expected.to contain_file('/etc/aliases').with_seltype('etc_aliases_t').with_content("# file managed by puppet\n") }

          it {
            is_expected.to contain_service('postfix').with(
              ensure: 'running',
              enable: 'true',
              hasstatus: 'true',
              restart: '/bin/systemctl reload postfix'
            )
          }
        end
      end

      context "when setting smtp_listen to 'all'" do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            smtp_listen: 'all',
            root_mail_recipient: 'foo',
            use_amavisd: true,
            use_dovecot_lda: true,
            use_schleuder: true,
            use_sympa: true,
            mail_user: 'bar',
            myorigin: 'localhost',
            inet_interfaces: 'localhost2',
            master_smtp: "smtp      inet  n       -       -       -       -       smtpd
    -o smtpd_client_restrictions=check_client_access,hash:/etc/postfix/access,reject",
            master_smtps: 'smtps     inet  n       -       -       -       -       smtpd',
            master_submission: 'submission inet n       -       -       -       -       smtpd',
          }
        end

        it { is_expected.to contain_package('postfix') }
        it { is_expected.to contain_exec('newaliases').with_refreshonly('true') }
        it { is_expected.to contain_postfix__config('myorigin').with_value('localhost') }
        it { is_expected.to contain_postfix__config('alias_maps').with_value('hash:/etc/aliases') }
        it { is_expected.to contain_augeas("manage postfix 'alias_maps'").with_changes("set alias_maps 'hash:/etc/aliases'") }
        it { is_expected.to contain_postfix__config('inet_interfaces').with_value('localhost2') }

        case facts[:os]['family']
        when 'FreeBSD'
          it { is_expected.not_to contain_package('mailx') }
        else
          it { is_expected.to contain_package('mailx') }
        end
        case facts[:os]['family']
        when 'Debian'
          it { is_expected.to contain_file('/etc/mailname').without('seltype').with_content("foo.example.com\n") }
          it { is_expected.to contain_file('/etc/aliases').without('seltype').with_content("# file managed by puppet\n") }

          it {
            is_expected.to contain_file(postfix_master_cf_path).without('seltype').with_content(
              %r{smtp      inet  n       -       -       -       -       smtpd}
            ).with_content(
              %r{amavis unix}
            ).with_content(
              %r{dovecot.*\n.* user=bar:bar }
            ).with_content(
              %r{schleuder}
            ).with_content(
              %r{sympa}
            ).with_content(
              %r{user=bar}
            ).with_content(
              %r{^smtp.*\n.*smtpd_client_restrictions=check_client_access,hash:}
            ).with_content(
              %r{^smtps     inet  n}
            ).with_content(
              %r{^submission inet n}
            )
          }

          it { is_expected.to contain_file(postfix_main_cf_path).without('seltype') }

          it {
            is_expected.to contain_service('postfix').with(
              ensure: 'running',
              enable: 'true',
              hasstatus: 'true',
              restart: '/etc/init.d/postfix reload'
            )
          }

        end

        it { is_expected.to contain_mailalias('root').with_recipient('foo') }
      end

      context 'when specifying inet_interfaces' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            inet_interfaces: 'localhost2',
          }
        end

        it 'creates a postfix::config defined type with inet_interfaces specified properly' do
          is_expected.to contain_postfix__config('inet_interfaces').with_value('localhost2')
        end
      end

      context 'when enabling ldap' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            ldap: true,
            ldap_base: 'cn=Users,dc=example,dc=com',
            ldap_host: 'ldaps://ldap.example.com:636 ldap://ldap2.example.com',
            ldap_options: 'start_tls = yes'
          }
        end

        it 'ldap is configured with all parameters ldap_base, ldap_host, ldap_options' do
          is_expected.to contain_class('postfix::ldap')
          is_expected.to contain_file("#{postfix_path}/ldap-aliases.cf")
        end

        context 'when on Debian family', if: facts[:osfamily] == 'Debian' do # rubocop:disable RSpec/MultipleMemoizedHelpers
          it { is_expected.to contain_package('postfix-ldap') }
        end
      end

      context 'when a custom mail_user is specified' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mail_user: 'bar',
          }
        end

        it 'adjusts the content of /etc/postfix/master.cf specifying the user' do
          is_expected.to contain_file(postfix_master_cf_path).with_content(%r{user=bar})
        end
      end

      context 'when mailman is true' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mailman: true,
          }
        end

        it 'compile and has required configuration' do
          is_expected.to compile.with_all_deps
          is_expected.to contain_class('postfix::mailman')
          is_expected.to contain_postfix__config('virtual_alias_maps').with_value("hash:#{postfix_virtual_path}")
          is_expected.to contain_augeas("manage postfix 'virtual_alias_maps'").with_changes("set virtual_alias_maps 'hash:#{postfix_virtual_path}'")
          is_expected.to contain_postfix__config('transport_maps').with_value("hash:#{postfix_transport_path}")
          is_expected.to contain_augeas("manage postfix 'transport_maps'").with_changes("set transport_maps 'hash:#{postfix_transport_path}'")
          is_expected.to contain_postfix__config('mailman_destination_recipient_limit').with_value('1')
          is_expected.to contain_augeas("manage postfix 'mailman_destination_recipient_limit'").with_changes("set mailman_destination_recipient_limit '1'")
          is_expected.to contain_postfix__hash(postfix_transport_path).with_ensure('present')
          is_expected.to contain_postfix__hash(postfix_virtual_path).with_ensure('present')
          is_expected.to contain_postfix__map(postfix_transport_path).with_ensure('present')
          is_expected.to contain_postfix__map(postfix_virtual_path).with_ensure('present')
          is_expected.to contain_file("postfix map #{postfix_transport_path}").with_ensure('present')
          is_expected.to contain_file("postfix map #{postfix_transport_path}.db").with_ensure('present')
          is_expected.to contain_file("postfix map #{postfix_virtual_path}").with_ensure('present')
          is_expected.to contain_file("postfix map #{postfix_virtual_path}.db").with_ensure('present')
          is_expected.to contain_exec("generate #{postfix_transport_path}.db")
          is_expected.to contain_exec("generate #{postfix_virtual_path}.db")
        end
      end

      context 'when specifying a custom mastercf_source' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mastercf_source: 'testy',
          }
        end

        it 'source of file is correct' do
          is_expected.to contain_file(postfix_master_cf_path).with_source('testy')
        end
      end

      context 'when specifying a custom mastercf_content' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mastercf_content: 'testy',
          }
        end

        it 'file content is correct' do
          is_expected.to contain_file(postfix_master_cf_path).with_content('testy')
        end
      end

      context 'when specifying a custom mastercf_template' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mastercf_template: 'testy',
          }
        end

        it 'does stuff' do
          skip 'need to write this still'
        end
      end

      context 'when specifying a custom mastercf_source and mastercf_content' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mastercf_source: 'testy_1',
            mastercf_content: 'testy_2',
          }
        end

        it 'fails' do
          expect { is_expected.to compile }.to raise_error(%r{mutually exclusive})
        end
      end

      context 'when specifying a custom mastercf_source and mastercf_template' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mastercf_source: 'testy_1',
            mastercf_template: 'testy_2',
          }
        end

        it 'fails' do
          expect { is_expected.to compile }.to raise_error(%r{mutually exclusive})
        end
      end

      context 'when specifying a custom mastercf_content and mastercf_template' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mastercf_content: 'testy_1',
            mastercf_template: 'testy_2',
          }
        end

        it 'fails' do
          expect { is_expected.to compile }.to raise_error(%r{mutually exclusive})
        end
      end

      context 'when specifying a mastercf_source and custom mastercf_content and mastercf_template' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mastercf_source: 'testy_1',
            mastercf_content: 'testy_2',
            mastercf_template: 'testy_3',
          }
        end

        it 'fails' do
          expect { is_expected.to compile }.to raise_error(%r{mutually exclusive})
        end
      end

      context 'when specifying a custom master_smtp' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            master_smtp: "smtp      inet  n       -       -       -       -       smtpd
  -o smtpd_client_restrictions=check_client_access,hash:/etc/postfix/access,reject",
          }
        end

        it 'updates master.cf with the specified flags to smtp' do
          is_expected.to contain_file(postfix_master_cf_path).with_content(
            %r{smtp      inet  n       -       -       -       -       smtpd}
          ).with_content(
            %r{^smtp.*\n.*smtpd_client_restrictions=check_client_access,hash:}
          )
        end
      end

      context 'when specifying a custom master_smtps' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            master_smtps: 'smtps     inet  n       -       -       -       -       smtpd',
          }
        end

        it 'updates master.cf with the specified flags to smtps' do
          is_expected.to contain_file(postfix_master_cf_path).with_content(%r{^smtps     inet  n})
        end
      end

      context 'when mta is enabled' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { mta: true, mydestination: '1.2.3.4', relayhost: '2.3.4.5' } }

        it 'configures postfix as a minimal MTA, delivering mail to the mydestination param' do
          is_expected.to contain_postfix__config('mydestination').with_value('1.2.3.4')
          is_expected.to contain_postfix__config('mynetworks').with_value('127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128')
          is_expected.to contain_postfix__config('relayhost').with_value('2.3.4.5')
          is_expected.to contain_postfix__config('virtual_alias_maps').with_value("hash:#{postfix_virtual_path}")
          is_expected.to contain_postfix__config('transport_maps').with_value("hash:#{postfix_transport_path}")
          is_expected.to contain_augeas("manage postfix 'virtual_alias_maps'").with_changes("set virtual_alias_maps 'hash:#{postfix_virtual_path}'")
          is_expected.to contain_augeas("manage postfix 'transport_maps'").with_changes("set transport_maps 'hash:#{postfix_transport_path}'")
        end

        it 'compiles with all resources' do
          is_expected.to compile.with_all_deps
          is_expected.to contain_class('postfix::mta')
        end

        context 'with masquerade settings' do # rubocop:disable RSpec/MultipleMemoizedHelpers
          let(:params) do
            super().merge(
              {
                masquerade_classes: ['envelope_sender'],
                masquerade_domains: ['host.example.com', 'example.com'],
                masquerade_exceptions: ['root']
              }
            )
          end

          it 'contain postfix::config types and augeas' do
            is_expected.to contain_postfix__config('masquerade_classes').with_value('envelope_sender')
            is_expected.to contain_augeas("manage postfix 'masquerade_classes'")
            is_expected.to contain_postfix__config('masquerade_domains').with_value('host.example.com example.com')
            is_expected.to contain_augeas("manage postfix 'masquerade_domains'")
            is_expected.to contain_postfix__config('masquerade_exceptions').with_value('root')
            is_expected.to contain_augeas("manage postfix 'masquerade_exceptions'")
          end
        end

        context "when mydestination => 'blank'" do # rubocop:disable RSpec/MultipleMemoizedHelpers
          let(:params) do
            super().merge({ mydestination: 'blank' })
          end

          it { is_expected.to contain_postfix__config('mydestination').with_ensure('blank').without_value }
        end

        context 'and satellite is also enabled' do # rubocop:disable RSpec/MultipleMemoizedHelpers
          let(:params) { { mta: true, satellite: true, mydestination: '1.2.3.4', relayhost: '2.3.4.5' } }

          it 'fails' do
            expect { is_expected.to compile }.to raise_error(%r{Please disable one})
          end
        end
      end

      context 'when specifying mydestination' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mta: true,
            mydestination: 'example.org, example.com, localhost.localdomain, localhost',
            relayhost: '2.3.4.5'
          }
        end

        it 'sets mydestination' do
          is_expected.to contain_postfix__config('mydestination').with_value('example.org, example.com, localhost.localdomain, localhost')
          is_expected.to contain_augeas("manage postfix 'mydestination'").with_changes("set mydestination 'example.org, example.com, localhost.localdomain, localhost'")
        end
      end

      context 'when specifying mynetworks' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mta: true,
            mydestination: '1.2.3.4',
            relayhost: 'direct',
            mynetworks: '127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 192.168.0.0/24'
          }
        end

        it 'mynetworks is configured' do
          is_expected.to contain_postfix__config('mynetworks').with_value('127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 192.168.0.0/24')
          is_expected.to contain_augeas("manage postfix 'mynetworks'").with_changes("set mynetworks '127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 192.168.0.0/24'")
        end
      end

      context 'when specifying myorigin' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { myorigin: 'localhost' } }

        it 'creates a postfix::config defined type with myorigin specified properly' do
          is_expected.to contain_postfix__config('myorigin').with_value('localhost')
        end
      end

      context 'when specifying relayhost' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            mta: true,
            relayhost: 'relay.example.org'
          }
        end

        it 'a relayhost is configured' do
          is_expected.to contain_postfix__config('relayhost').with_value('relay.example.org')
          is_expected.to contain_augeas("manage postfix 'relayhost'").with_changes("set relayhost 'relay.example.org'")
        end
      end

      context 'when specifying a root_mail_recipient' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { root_mail_recipient: 'foo' } }

        it 'contains a Mailalias resource directing roots mail to the required user' do
          is_expected.to contain_mailalias('root').with_recipient('foo')
        end
      end

      context 'when specifying satellite' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { satellite: true, mydestination: '1.2.3.4', relayhost: '2.3.4.5' } }
        let :pre_condition do
          "class { 'augeas': }"
        end

        it 'compiles with expected resources' do
          is_expected.to compile.with_all_deps
          is_expected.to contain_class('postfix::satellite')
          is_expected.to contain_postfix__virtual('@foo.example.com').with(ensure: 'present', destination: 'root')
          is_expected.to contain_augeas('Postfix virtual - @foo.example.com')
          is_expected.to contain_class('postfix::augeas')
          is_expected.to contain_augeas__lens('postfix_virtual').with(
            ensure: 'present',
            lens_content: %r{Parses /etc/postfix/virtual},
            test_content: %r{Provides unit tests and examples for the <Postfix_Virtual> lens.},
            stock_since: '1.7.0'
          )
        end

        it 'configures all local email to be forwarded to $root_mail_recipient delivered through $relayhost' do
          is_expected.to contain_postfix__config('mydestination').with_value('1.2.3.4')
          is_expected.to contain_postfix__config('mynetworks').with_value('127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128')
          is_expected.to contain_postfix__config('relayhost').with_value('2.3.4.5')
          is_expected.to contain_postfix__config('virtual_alias_maps').with_value("hash:#{postfix_virtual_path}")
          is_expected.to contain_augeas("manage postfix 'virtual_alias_maps'").with_changes("set virtual_alias_maps 'hash:#{postfix_virtual_path}'")
          is_expected.to contain_postfix__config('transport_maps').with_value("hash:#{postfix_transport_path}")
          is_expected.to contain_augeas("manage postfix 'transport_maps'").with_changes("set transport_maps 'hash:#{postfix_transport_path}'")
        end

        context 'and mta is also enabled' do # rubocop:disable RSpec/MultipleMemoizedHelpers
          let(:params) { { mta: true, satellite: true, mydestination: '1.2.3.4', relayhost: '2.3.4.5' } }

          it 'fails' do
            expect { is_expected.to compile }.to raise_error(%r{Please disable one})
          end
        end
      end

      context 'when specifying smtp_listen' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { smtp_listen: 'all' } }

        it 'updates master.cf to listen to all addresses' do
          is_expected.to contain_file(postfix_master_cf_path).with_content(
            %r{smtp      inet  n       -       n       -       -       smtpd}
          )
        end
      end

      context 'when specifying multiple smtp_listen addresses as string' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { smtp_listen: '192.168.0.123 10.0.0.123' } }

        it 'updates master.cf with multiple smtp listeners' do
          is_expected.to contain_file(postfix_master_cf_path).with_content(
            %r{192.168.0.123:smtp      inet  n       -       n       -       -       smtpd}
          ).with_content(
            %r{10.0.0.123:smtp      inet  n       -       n       -       -       smtpd}
          )
        end
      end

      context 'when specifying multiple smtp_listen addresses as array' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { smtp_listen: ['192.168.0.123', '10.0.0.123'] } }

        it 'updates master.cf with multiple smtp listeners' do
          is_expected.to contain_file(postfix_master_cf_path).with_content(
            %r{192.168.0.123:smtp      inet  n       -       n       -       -       smtpd}
          ).with_content(
            %r{10.0.0.123:smtp      inet  n       -       n       -       -       smtpd}
          )
        end
      end

      context 'when use_amavisd is true' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { use_amavisd: true } }

        it 'updates master.cf with the specified flags to amavis' do
          is_expected.to contain_file(postfix_master_cf_path).with_content(%r{amavis unix})
        end
      end

      context 'when use_dovecot_lda is true' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { use_dovecot_lda: true } }

        it 'updates master.cf with the specified flags to dovecot' do
          is_expected.to contain_file(postfix_master_cf_path).with_content(%r{dovecot.*\n.* user=vmail:vmail })
        end
      end

      context 'when use_schleuder is true' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { use_schleuder: true } }

        it 'updates master.cf with the specified flags to schleuder' do
          is_expected.to contain_file(postfix_master_cf_path).with_content(%r{schleuder})
        end
      end

      context 'when use_sympa is true' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { use_sympa: true } }

        it 'updates master.cf to include sympa' do
          is_expected.to contain_file(postfix_master_cf_path).with_content(%r{sympa})
        end
      end

      context 'when manage_root_alias is false' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { manage_root_alias: false } }

        it 'does not manage root mailalias' do
          is_expected.not_to contain_mailalias('root')
        end
      end

      context 'when manage_mailx is false' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) { { manage_mailx: false } }

        it 'does not have mailx package' do
          is_expected.not_to contain_package('mailx')
        end
      end

      context 'when config hash is used' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            configs: {
              'message_size_limit' => {
                'value' => '51200000',
              },
            },
          }
        end

        it 'updates main.cf with the specified contents' do
          is_expected.to contain_postfix__config('message_size_limit').with_value('51200000')
          is_expected.to contain_augeas("manage postfix 'message_size_limit'").with_changes("set message_size_limit '51200000'")
        end
      end

      context 'when hashes hash is used' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            hashes: {
              '/etc/postfix/transport' => {
                'ensure' => 'present',
              },
            },
          }
        end

        it 'creates the hash' do
          is_expected.to contain_postfix__hash('/etc/postfix/transport').with_ensure('present')
        end
      end

      context 'when transports hash is used' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            transports: {
              'local_relay' => {
                'nexthop' => '[10.12.0.2]:9925',
              },
            },
          }
        end

        it 'updates the transport map' do
          is_expected.to contain_postfix__transport('local_relay').with_nexthop('[10.12.0.2]:9925')
          is_expected.to contain_augeas('Postfix transport - local_relay')
          is_expected.to contain_class('postfix::augeas')
          is_expected.to contain_augeas__lens('postfix_transport').with(
            ensure: 'present',
            lens_content: %r{Parses /etc/postfix/transport},
            test_content: %r{Provides unit tests and examples for the <Postfix_Transport> lens.},
            stock_since: '1.0.0'
          )
        end
      end

      context 'when virtuals hash is used' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            virtuals: {
              'someone@somedomain.tld' => {
                'destination' => 'internal@ourdomain.tld',
              },
            },
          }
        end

        it 'updates the virtual map' do
          is_expected.to contain_postfix__virtual('someone@somedomain.tld').with_destination('internal@ourdomain.tld')
          is_expected.to contain_augeas('Postfix virtual - someone@somedomain.tld')
          is_expected.to contain_class('postfix::augeas')
          is_expected.to contain_augeas__lens('postfix_virtual').with(
            ensure: 'present',
            lens_content: %r{Parses /etc/postfix/virtual},
            test_content: %r{Provides unit tests and examples for the <Postfix_Virtual> lens.},
            stock_since: '1.7.0'
          )
        end
      end

      context 'when conffiles hash is used' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            conffiles: {
              'ldapoptions.cf' => {
                'mode' => '0640',
                'options' => {
                  'server_host' => 'ldap.mydomain.com',
                  'bind' => 'yes',
                  'bind_dn' => 'cn=admin,dc=mydomain,dc=com',
                  'bind_pw' => 'password',
                  'search_base' => 'dc=example, dc=com',
                  'query_filter' => 'mail=%s',
                  'result_attribute' => 'uid',
                },
              },
            },
          }
        end

        it 'creates ldapoptions.cf with the specified contents' do
          is_expected.to contain_postfix__conffile('ldapoptions.cf').with(
            'mode' => '0640',
            'options' => {
              'server_host' => 'ldap.mydomain.com',
              'bind' => 'yes',
              'bind_dn' => 'cn=admin,dc=mydomain,dc=com',
              'bind_pw' => 'password',
              'search_base' => 'dc=example, dc=com',
              'query_filter' => 'mail=%s',
              'result_attribute' => 'uid',
            }
          )
          is_expected.to contain_file('postfix conffile ldapoptions.cf').with_ensure('present')
        end
      end

      context 'when maps hash is used' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            maps: {
              'a_map' => {
                'type' => 'regexp',
                'content' => 'abc xyz',
              },
            },
          }
        end

        it 'creates the map resource' do
          is_expected.to contain_postfix__map('a_map').with(
            'type' => 'regexp',
            'content' => 'abc xyz'
          )
          is_expected.to contain_exec('generate a_map.db')
          is_expected.to contain_file('postfix map a_map')
        end
      end
    end
  end
end
