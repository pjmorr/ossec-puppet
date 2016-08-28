# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'
describe 'ossec::server' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(concat_basedir: '/dummy')
      end
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
  end
end
