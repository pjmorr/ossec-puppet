# Setup for ossec client
class ossec::client(
  $ossec_active_response   = true,
  $ossec_rootcheck         = true,
  $ossec_server_ip         = undef,
  $ossec_server_hostname   = undef,
  $ossec_scanpaths         = [],
  $ossec_emailnotification = 'yes',
  $ossec_ignorepaths       = [],
  $ossec_local_files       = {},
  $ossec_check_frequency   = 79200,
  $ossec_prefilter         = false,
  $ossec_service_provider  = $::ossec::params::ossec_service_provider,
  $selinux                 = false,
  $agent_name              = $::hostname,
  $agent_ip_address        = $::ipaddress,
  $manage_repo             = true,
  $manage_epel_repo        = true,
  $manage_client_keys      = true,
  $max_clients             = 3000,
  $ar_repeated_offenders   = '',
) inherits ossec::params {
  validate_bool(
    $ossec_active_response, $ossec_rootcheck,
    $selinux, $manage_repo, $manage_epel_repo
  )
  # This allows arrays of integers, sadly
  # (commented due to stdlib version requirement)
  #validate_integer($ossec_check_frequency, undef, 1800)
  validate_array($ossec_ignorepaths)

  if ( ( $ossec_server_ip == undef ) and ( $ossec_server_hostname == undef ) ) {
    fail('must pass either $ossec_server_ip or $ossec_server_hostname to Class[\'ossec::client\'].')
  }

  case $::kernel {
    'Linux' : {
      if $manage_repo {
      class { 'ossec::repo': redhat_manage_epel => $manage_epel_repo }
      Class['ossec::repo'] -> Package[$ossec::params::agent_package]
        package { $ossec::params::agent_package:
          ensure  => installed
      }

      } else {
      package { $ossec::params::agent_package:
        ensure => installed
      }
      }
    }
    'windows' : {

          file {
          'C:/ossec-win32-agent-2.8.3.exe':
          owner              => 'Administrators',
          group              => 'Administrators',
          mode               => '0774',
          source             => 'puppet:///modules/ossec/ossec-win32-agent-2.8.3.exe',
          source_permissions => ignore
          }

      package { $ossec::params::agent_package:
        ensure          => installed,
        source          => 'C:/ossec-win32-agent-2.8.3.exe',
        install_options => [ '/S' ],  # Nullsoft installer silent installation
        require         => File['C:/ossec-win32-agent-2.8.3.exe'],
      }
    }
    default: { fail('OS not supported') }
  }

  service { $ossec::params::agent_service:
    ensure    => running,
    enable    => true,
    hasstatus => $ossec::params::service_has_status,
    pattern   => $ossec::params::agent_service,
    provider  => $ossec_service_provider,
    require   => Package[$ossec::params::agent_package],
  }

  concat { $ossec::params::config_file:
    owner   => $ossec::params::config_owner,
    group   => $ossec::params::config_group,
    mode    => $ossec::params::config_mode,
    require => Package[$ossec::params::agent_package],
    notify  => Service[$ossec::params::agent_service],
  }

  concat::fragment { 'ossec.conf_10' :
    target  => $ossec::params::config_file,
    content => template('ossec/10_ossec_agent.conf.erb'),
    order   => 10,
    notify  => Service[$ossec::params::agent_service]
  }

  if ( $ar_repeated_offenders != '' and $ossec_active_response == true ) {
    concat::fragment { 'repeated_offenders' :
      target  => $ossec::params::config_file,
      content => template('ossec/ar_repeated_offenders.erb'),
      order   => 55,
      notify  => Service[$ossec::params::agent_service]
    }
  }

  concat::fragment { 'ossec.conf_99' :
    target  => $ossec::params::config_file,
    content => template('ossec/99_ossec_agent.conf.erb'),
    order   => 99,
    notify  => Service[$ossec::params::agent_service]
  }

  if ( $manage_client_keys == true ) {
    concat { $ossec::params::keys_file:
      owner   => $ossec::params::keys_owner,
      group   => $ossec::params::keys_group,
      mode    => $ossec::params::keys_mode,
      notify  => Service[$ossec::params::agent_service],
      require => Package[$ossec::params::agent_package]
    }

    ossec::agentkey{ "ossec_agent_${agent_name}_client":
      agent_id         => fqdn_rand($max_clients),
      agent_name       => $agent_name,
      agent_ip_address => $agent_ip_address,
    }

    @@ossec::agentkey{ "ossec_agent_${agent_name}_server":
      agent_id         => fqdn_rand($max_clients),
      agent_name       => $agent_name,
      agent_ip_address => $agent_ip_address
    }
  } elsif ($::kernel == 'Linux') {
    # Is this really Linux only?
    $ossec_server_address = pick($ossec_server_ip, $ossec_server_hostname)
    exec { 'agent-auth':
      command => "/var/ossec/bin/agent-auth -m ${ossec_server_address} -A ${::fqdn} -D /var/ossec/",
      creates => '/var/ossec/etc/client.keys',
      require => Package[$ossec::params::agent_package],
    }
  }

  if ($::kernel == 'Linux') {
    # Set log permissions properly to fix
    # https://github.com/djjudas21/puppet-ossec/issues/20
    file { '/var/ossec/logs':
      ensure  => directory,
      require => Package[$ossec::params::agent_package],
      owner   => 'ossec',
      group   => 'ossec',
      mode    => '0750',
    }

    # SELinux
    # Requires selinux module specified in metadata.json
    if ($::osfamily == 'RedHat' and $selinux == true) {
      selinux::module { 'ossec-logrotate':
        ensure => 'present',
        source => 'puppet:///modules/ossec/ossec-logrotate.te',
      }
    }
  }
}
