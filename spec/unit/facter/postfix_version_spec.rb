require 'spec_helper'

describe Facter::Util::Fact.to_s do
  before(:each) do
    Facter.clear
  end

  describe 'postfix_version' do
    context 'with value' do
      before :each do
        Facter::Core::Execution.stubs(:which).with('postconf').returns('/usr/sbin/postconf')
        Facter::Util::Resolution.stubs(:exec).with('postconf mail_version').returns('mail_version = 3.4.8')
      end
      it {
        expect(Facter.fact(:postfix_version).value).to eq('3.4.8')
      }
    end
  end
end