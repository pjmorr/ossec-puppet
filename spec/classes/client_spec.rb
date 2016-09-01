# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper_puppet'
describe 'ossec::client', type: :class do
  let(:facts) { Testing::RspecPuppet::SharedFacts.oraclelinux_facts }
  extend Testing::RspecPuppet::SharedExamples
  context 'with defaults for all parameters' do
    it do
      expect { is_expected.to compile.with_all_deps }.to raise_error(/must pass either/)
    end
  end

  context 'with ossec_server_ip' do
    let (:params) do
      {
        ossec_server_ip: '127.0.0.1'
      }
    end
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('ossec::client') }
    it { is_expected.to contain_file('/var/ossec/logs') }
    it { is_expected.to contain_concat('/var/ossec/etc/ossec.conf') }
    it { is_expected.to contain_concat('/var/ossec/etc/client.keys') }
    it { is_expected.not_to contain_Concat__Fragment('ossec.conf_10').with_content(/<server-hostname>local.test<\/server-hostname>/) }
    it { is_expected.to contain_Concat__Fragment('ossec.conf_10').with_content(/<server-ip>127.0.0.1<\/server-ip>/) }
    it { is_expected.to contain_Concat__Fragment('ossec.conf_99').with_content(/<\/ossec_config>/) }
    it { is_expected.to contain_Concat__Fragment('var_ossec_etc_client.keys_hostname_part') }
    it { is_expected.to contain_Package('inotify-tools') }
    it { is_expected.to contain_Package('wazuh-agent') }
    it { is_expected.to contain_Service('wazuh-agent') }
    it { is_expected.to contain_Yumrepo('wazuh') }
    it { is_expected.to contain_ossec__agentkey('ossec_agent_hostname_client') }
  end

  context 'with ossec_server_hostname' do
    let (:params) do
      {
        ossec_server_hostname: 'local.test'
      }
    end
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('ossec::client') }
    it { is_expected.to contain_file('/var/ossec/logs') }
    it { is_expected.to contain_concat('/var/ossec/etc/ossec.conf') }
    it { is_expected.to contain_concat('/var/ossec/etc/client.keys') }
    it { is_expected.not_to contain_Concat__Fragment('ossec.conf_10').with_content(/<server-ip>127.0.0.1<\/server-ip>/) }
    it { is_expected.to contain_Concat__Fragment('ossec.conf_10').with_content(/<server-hostname>local.test<\/server-hostname>/) }
    it { is_expected.to contain_Concat__Fragment('ossec.conf_99').with_content(/<\/ossec_config>/) }
    it { is_expected.to contain_Concat__Fragment('var_ossec_etc_client.keys_hostname_part') }
    it { is_expected.to contain_Package('inotify-tools') }
    it { is_expected.to contain_Package('wazuh-agent') }
    it { is_expected.to contain_Service('wazuh-agent') }
    it { is_expected.to contain_Yumrepo('wazuh') }
    it { is_expected.to contain_ossec__agentkey('ossec_agent_hostname_client') }
  end
end
