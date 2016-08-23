require 'spec_helper_acceptance'

describe 'postfix class' do

  context 'default parameters' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        # Make sure the default mailer is stopped in docker containers
        if $::operatingsystem == 'Debian' {
          service { 'exim4':
            ensure    => stopped,
            hasstatus => false,
            before    => Class['postfix'],
          }
        }
        if $::osfamily == 'RedHat' {
          service { 'sendmail':
            ensure    => stopped,
            hasstatus => false,
            before    => Class['postfix'],
          }
        }

        class { 'postfix': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('postfix') do
      it { is_expected.to be_installed }
    end

    describe service('postfix') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
