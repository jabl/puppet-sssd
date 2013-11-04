#
class sssd::config inherits sssd {

  file { $config:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0600',
    content => template($config_template),
  }

}
