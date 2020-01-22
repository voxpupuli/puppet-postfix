require 'spec_helper'

describe 'postfix::mailman' do
  let :pre_condition do
    'include ::postfix'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
