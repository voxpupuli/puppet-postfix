require 'spec_helper'

describe 'postfix::satellite' do
  let (:facts) { {
    :osfamily            => 'Debian',
    :needs_postfix_class => true,
  } }
  it { should include_class('postfix::mta') }
  it { should contain_postfix__virtual('@foo.example.com').with(
    :ensure      => 'present',
    :destination => 'root'
  ) }
end
