require 'spec_helper'

describe Facter.fact(:postfix_version) do
  before(:each) do
    Facter.clear
  end

  describe 'postfix_version' do
    context 'with value' do
      before :each do
        Facter::Util::Resolution.stubs(:which).with('postconf').returns('/usr/sbin/postconf')
        Facter::Util::Resolution.stubs(:exec).with('postconf mail_version').returns('mail_version = 3.4.8')
      end
      it {
        expect(Facter.fact(:mysql_version).value).to eq('3.4.8')
      }
    end
  end
end
