require 'spec_helper'

describe 'postfix::satellite' do
  let (:node) { 'foo.example.com' }
  let (:facts) { {
    :osfamily                        => 'Debian',
    :needs_postfix_class_with_params => true,
  } }
  it { should include_class('postfix::mta') }
  it { should contain_postfix__virtual('@foo.example.com').with(
    :ensure      => 'present',
    :destination => 'root'
  ) }
end
