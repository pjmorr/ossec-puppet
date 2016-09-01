# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper_puppet'

describe 'ossec::agentkey', type: :define do
  shared_examples 'containing class structure' do
    it { is_expected.to compile.with_all_deps }
  end

  shared_examples 'containing self' do
    it do
      is_expected.to contain_ossec__agentkey(title).with(agent_id: '2',
                                                         agent_name: 'test',
                                                         agent_ip_address: '192.168.2.2')
    end
  end

  shared_examples 'raise error' do
    it { is_expected.to compile.with_all_deps }
  end

  context 'On RedHat os family' do
    extend Testing::RspecPuppet::SharedExamples
    let(:facts) { Testing::RspecPuppet::SharedFacts.oraclelinux_facts }
    context 'valid agentkey' do
      let(:title) { 'ossec_agent_hostname_client' }
      let(:params) do
        {
          agent_id: '2',
          agent_name: 'test',
          agent_ip_address: '192.168.2.2'
        }
      end
      it_behaves_like 'containing self'
    end

    context 'invalid agentkey' do
      let(:title) { 'ossec_agent_hostname_client' }
      let(:params) do
        {
          agent_id: '',
          agent_name: '',
          agent_ip_address: ''
        }
        it_behaves_like 'raise error'
      end
    end
    context 'valid agentkey' do
      let(:title) { 'ossec_agent_test_client' }
      let(:params) do
        {
          agent_id: '2',
          agent_name: 'test',
          agent_ip_address: '192.168.2.2'
        }
      end
      it_behaves_like 'containing self'
    end
    context 'invalid agentkey' do
      let(:title) { 'ossec_agent_test_client' }
      let(:params) do
        {
          agent_id: '',
          agent_name: '',
          agent_ip_address: ''
        }
        it_behaves_like 'raise error'
      end
    end
  end

  context 'On Debian os family' do
    extend Testing::RspecPuppet::SharedExamples
    let(:facts) { Testing::RspecPuppet::SharedFacts.ubuntu_facts }

    context 'valid agentkey' do
      let(:title) { 'ossec_agent_hostname_client' }
      let(:params) do
        {
          agent_id: '2',
          agent_name: 'test',
          agent_ip_address: '192.168.2.2'
        }
      end
      it_behaves_like 'containing self'
    end

    context 'invalid agentkey' do
      let(:title) { 'ossec_agent_hostname_client' }
      let(:params) do
        {
          agent_id: '',
          agent_name: '',
          agent_ip_address: ''
        }
        it_behaves_like 'raise error'
      end
    end
    context 'valid agentkey' do
      let(:title) { 'ossec_agent_test_client' }
      let(:params) do
        {
          agent_id: '2',
          agent_name: 'test',
          agent_ip_address: '192.168.2.2'
        }
      end
      it_behaves_like 'containing self'
    end
    context 'invalid agentkey' do
      let(:title) { 'ossec_agent_test_client' }
      let(:params) do
        {
          agent_id: '',
          agent_name: '',
          agent_ip_address: ''
        }
        it_behaves_like 'raise error'
      end
    end
  end
end
