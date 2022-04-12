# frozen_string_literal: true

require 'spec_helper'

describe 'postfix::mta' do
  let :pre_condition do
    "class { 'postfix':
      mydestination => 'bar',
      mynetworks    => '127.0.0.1/8, [::1]/128 ![::2]/128',
      relayhost     => 'foo',
      masquerade_classes => ['envelope_sender'],
      masquerade_domains => ['host.example.com',  'example.com'],
      masquerade_exceptions => ['root'],
    }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_postfix__config('mydestination').with_value('bar') }
      it { is_expected.to contain_postfix__config('mynetworks').with_value('127.0.0.1/8, [::1]/128 ![::2]/128') }
      it { is_expected.to contain_postfix__config('relayhost').with_value('foo') }
      it { is_expected.to contain_postfix__config('masquerade_classes').with_value('envelope_sender') }
      it { is_expected.to contain_postfix__config('masquerade_domains').with_value('host.example.com example.com') }
      it { is_expected.to contain_postfix__config('masquerade_exceptions').with_value('root') }

      context "when mydestination => 'blank'" do
        let :pre_condition do
          "class { 'postfix':
            mydestination => 'blank',
            mynetworks    => '127.0.0.1/8, [::1]/128 ![::2]/128',
            relayhost     => 'foo',
          }"
        end

        it { is_expected.to contain_postfix__config('mydestination').with_ensure('blank').without_value }
      end
    end
  end
end
