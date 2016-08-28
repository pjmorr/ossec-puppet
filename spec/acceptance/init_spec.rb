# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper_acceptance'

describe 'init smoke test', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  let(:pp) { Testing::Acceptance::SmokeTestReader.smoke_pp :init }

  it 'should run aws_resources with no errors' do
    apply_manifest(pp, catch_failures: true)
  end
  it 'should work idempotently' do
    apply_manifest(pp, catch_changes: true)
  end
  describe 'aws_resources', type: :class do
    it { is_expected.to compile }
    it { is_expected.to contain_class('aws_resources') }
  end
  after(:all) do
    extend Testing::Acceptance::Cleaner
    # remove_jboss_installation('wildfly')
  end
end
