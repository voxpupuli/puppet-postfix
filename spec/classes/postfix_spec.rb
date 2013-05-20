require 'spec_helper'

describe 'postfix' do
  context 'when on Debian' do
    let (:facts) { {
      :operatingsystem => 'Debian',
      :osfamily        => 'Debian',
    } }

    it { should contain_package('postfix') }
  end

  context 'when on RedHat' do
    let (:facts) { {
      :operatingsystem => 'RedHat',
      :osfamily        => 'RedHat',
    } }

    it { should contain_package('postfix') }
  end
end
