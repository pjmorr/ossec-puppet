# encoding: utf-8
# frozen_string_literal: true
module Testing::RspecPuppet::SharedExamples
  DEFAULT_VERSION = '2.0.15'.freeze
  DEFAULT_PRODUCT = 'ossec'.freeze
  DEFAULT_WITH    = [
    :anchors,
    :interfaces,
    :packages
  ].freeze
  DEFAULT_OPTIONS = {
    product: DEFAULT_PRODUCT,
    version: DEFAULT_VERSION,
    with: DEFAULT_WITH
  }.freeze

  def containing_basic_class_structure
    name = 'containing basic class structure'
    shared_examples(name) do
      it { is_expected.to compile }
      it { is_expected.to contain_class 'ossec' }
      it { is_expected.to contain_class 'ossec::params' }
      it { is_expected.to contain_class 'ossec::repo' }
    end
    name
  end

  def common_anchors
    anchor_list = [
      'begin', 'end', 'configuration::begin', 'configuration::end',
      'installed', 'package::begin', 'package::end',
      'service::begin', 'service::end', 'service::started'
    ].map { |item| "ossec::#{item}" }
    name = 'having common anchors'
    shared_examples(name) do
      anchor_list.each do |item|
        it { is_expected.to contain_anchor(item.to_s) }
      end
    end
    name
  end
end
