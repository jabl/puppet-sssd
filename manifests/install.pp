class sssd::install inherits sssd {
  
  package { $sssd::package_list:
    ensure => $package_ensure,
  }
  
}
        
