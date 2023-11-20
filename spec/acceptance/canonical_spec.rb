# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postfix::canonical' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
        include postfix
        postfix::hash { '/etc/postfix/recipient_canonical':
          ensure => present,
        }
        postfix::config { 'canonical_alias_maps':
          value => 'hash:/etc/postfix/recipient_canonical',
        }
        postfix::canonical { 'user@example.com':
          file        => '/etc/postfix/recipient_canonical',
          ensure      => present,
          destination => 'root',
        }
      PUPPET
    end
  end
end
