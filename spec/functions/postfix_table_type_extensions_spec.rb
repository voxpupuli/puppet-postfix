# frozen_string_literal: true

require 'spec_helper'

describe 'postfix::table_type_extension' do
  context 'random string' do
    it { is_expected.to run.with_params('foo').and_return('db') }
  end

  context 'with lmdb' do
    it { is_expected.to run.with_params('lmdb').and_return('lmdb') }
  end

  context 'with pcre' do
    it { is_expected.to run.with_params('pcre').and_return('db') }
  end
end
