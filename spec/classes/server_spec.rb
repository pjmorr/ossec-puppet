# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper_puppet'
describe 'ossec::server', type: :class do
  let(:facts) { Testing::RspecPuppet::SharedFacts.oraclelinux_facts }
  extend Testing::RspecPuppet::SharedExamples
  context 'with defaults for all parameters' do
    it do
      expect { is_expected.to compile.with_all_deps }.to raise_error(/expects a value for/)
    end
  end

  context 'with valid paramaters' do
    let (:params) do
      {
        mailserver_ip: "127.0.0.1",
        ossec_emailto: "root@localhost.com",
      }
    end
    # it { is_expected.to compile.with_all_deps }
    # it { should contain_class('Ossec::Server') }
  end
end
