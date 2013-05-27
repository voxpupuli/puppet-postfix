require 'spec_helper'

describe 'postfix::mta' do
  let (:facts) { {
    :needs_postfix_class_with_params => true,
    :osfamily                        => 'Debian',
  } }

  it { should contain_postfix__config('mydestination').with_value('bar') }
  it { should contain_postfix__config('mynetworks').with_value('baz') }
  it { should contain_postfix__config('relayhost').with_value('foo') }
end
