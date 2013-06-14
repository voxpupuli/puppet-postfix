require 'spec_helper'

describe 'postfix', :type => :class do
  context "on a Redhat 6 OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :lsbmajdistrelease      => '6',
        :operatingsystemrelease => '6',
      }
    end
    it { should include_class('postfix') }
  end
  context "on a Debian 6 OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :lsbmajdistrelease      => '6',
        :operatingsystemrelease => '6',
      }
    end
    it { should include_class('postfix') }
  end
end
