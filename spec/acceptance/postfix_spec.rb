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

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true, debug: true)
=begin
require 'fileutils'

dir = '/tmp'
suffix = '.backup'

Dir.glob(File.join(dir, '*.pp')).each do |file|
  next unless File.file?(file)

  backup_path = "#{file}#{suffix}"
  FileUtils.cp(file, backup_path)
  puts "Backed up #{file} -> #{backup_path}"
end

puts 'Done.'
      raise "wird angehalten für interaktive Inspektion"
=end
      Kernel.sleep(10)
      apply_manifest(pp, catch_changes: true, debug: true)
    end

    describe command('journalctl --unit postfix --boot --no-pager --no-hostname') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain('postfix') }
    end

    describe command('systemctl cat postfix.service') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain('postfix') }
    end

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
