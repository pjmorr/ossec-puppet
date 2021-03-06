# encoding: utf-8
# frozen_string_literal: true
class Testing::RspecPuppet::SharedFacts
  DEFAULT_IP         = '192.168.0.1'.freeze
  DEFAULT_CONCAT_DIR = '/root/concat'.freeze

  DEFAULT_ORACLELINUX_FACTS = {
    kernel: 'Linux',
    hostname: 'hostname',
    operatingsystem: 'OracleLinux',
    osfamily: 'RedHat',
    ipaddress: DEFAULT_IP,
    concat_basedir: DEFAULT_CONCAT_DIR,
    operatingsystemrelease: '6.7',
    operatingsystemmajrelease: '6',
    puppetversion: Puppet.version.to_s,
    path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  }.freeze
  DEFAULT_UBUNTU_RELEASE = '14.04'.freeze
  DEFAULT_UBUNTU_FACTS = {
    kernel: 'Linux',
    hostname: 'hostname',
    operatingsystem: 'Ubuntu',
    osfamily: 'Debian',
    ipaddress: DEFAULT_IP,
    concat_basedir: DEFAULT_CONCAT_DIR,
    operatingsystemmajrelease: DEFAULT_UBUNTU_RELEASE,
    operatingsystemrelease: DEFAULT_UBUNTU_RELEASE,
    lsbdistcodename: 'trusty',
    lsbdistdescription: 'Ubuntu 14.04.3 LTS',
    lsbdistid: 'Ubuntu',
    lsbdistrelease: DEFAULT_UBUNTU_RELEASE,
    lsbmajdistrelease: DEFAULT_UBUNTU_RELEASE,
    puppetversion: Puppet.version.to_s,
    path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  }.freeze
  class << self
    def ubuntu_facts(override = {})
      DEFAULT_UBUNTU_FACTS.merge(override)
    end

    def oraclelinux_facts(override = {})
      DEFAULT_ORACLELINUX_FACTS.merge(override)
    end
  end
end
