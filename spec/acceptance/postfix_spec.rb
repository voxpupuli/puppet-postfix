# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postfix class' do
  context 'default parameters' do
    it 'works idempotently with no errors' do
      pp = <<-EOS
        # Make sure the default mailer is stopped in docker containers
        if fact('os.name') == 'Debian' {
          service { 'exim4':
            ensure    => stopped,
            hasstatus => false,
            before    => Class['postfix'],
          }
        }
        if fact('os.family') == 'RedHat' {
          service { 'sendmail':
            ensure    => stopped,
            hasstatus => false,
            before    => Class['postfix'],
          }
        }

        class { 'postfix':
          smtp_listen => 'all',
        }
      EOS

      shell ('systemctl stop postfix || true')
      # Run it twice and test for idempotency
      puts "Marcus Debug Marker 1"
      shell( '/usr/sbin/ss -lnp |grep 25; systemctl status postfix || true' )
      apply_manifest(pp, catch_failures: true, debug: false)
      # Sep 30 13:13:22 rocky8-64-openvox8.example.com postfix/master[1400]: fatal: bind 0.0.0.0 port 25: Address already in use
      shell( '/usr/sbin/ss -lnp |grep 25; systemctl status postfix || true' )
      apply_manifest(pp, catch_changes: true, debug: false)
      shell( '/usr/sbin/ss -lnp |grep 25; systemctl status postfix || true' )
    end

    # rubocop:disable RSpec/RepeatedExampleGroupBody
    # rubocop:enable RSpec/RepeatedExampleGroupBody

    describe package('postfix') do
      it { is_expected.to be_installed }
    end

    describe service('postfix') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe file('/etc/aliases', '/usr/bin/mailx') do
      it { is_expected.to exist }
    end
  end

  context 'default parameters with manage_aliase as false' do
    it 'works idempotently with no errors and with your own configuration of /etc/aliases' do
      pp = <<-EOS
        # Make sure the default mailer is stopped in docker containers
        if fact('os.name') == 'Debian' {
          service { 'exim4':
            ensure    => stopped,
            hasstatus => false,
            before    => Class['postfix'],
          }
        }
        if fact('os.family') == 'RedHat' {
          service { 'sendmail':
            ensure    => stopped,
            hasstatus => false,
            before    => Class['postfix'],
          }
        }
        class { 'postfix':
          smtp_listen    => 'all',
          manage_aliases => false,
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
