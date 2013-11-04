class sssd::params {

  $config          = '/etc/sssd/sssd.conf'
  $config_template = 'sssd/sssd.conf.erb'
  $package_ensure  = 'present'
  $service_name    = 'sssd'
  $service_ensure  = 'running'
  $service_enable  = true
  $service_manage  = true

  case $::osfamily {
    'Debian': {
      $package_list    = [ 'sssd' ]
    }
    'RedHat': {
      $package_list    = [ 'sssd', 'sssd-client' ]
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
