# frozen_string_literal: true

require 'spec_helper'

describe 'postfix::canonical' do
  let(:title) { 'foo@example.com' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end
      let(:params) do
        {
          ensure: 'present',
          file: '/etc/postfix/recipient_canonical',
          destination: 'root',
        }
      end

      context 'without related postfix::map resource' do
        it { is_expected.not_to compile.with_all_deps }
      end

      context 'with related postfix::map resource' do
        let :pre_condition do
          <<-PUPPET
          postfix::config { 'canonical_alias_maps':
           value => 'hash:/etc/postfix/recipient_canonical',
          }
          postfix::hash { '/etc/postfix/recipient_canonical':
          }
          PUPPET
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
