# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper_puppet'
describe 'ossec', type: :class do
  let(:facts) { Testing::RspecPuppet::SharedFacts.oraclelinux_facts }
  extend Testing::RspecPuppet::SharedExamples
  context 'with defaults for all parameters' do
    it { is_expected.to compile }
    it do
      is_expected.to contain_class('ossec').with(product: 'ossec',
                                                 version: '2.0.15')
    end
  end
end
