# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper_puppet'
describe 'ossec::repo', type: :class do
  let(:facts) { Testing::RspecPuppet::SharedFacts.oraclelinux_facts }
  extend Testing::RspecPuppet::SharedExamples
  it { is_expected.to compile }
  it { is_expected.to contain_class 'ossec::repo' }
end
