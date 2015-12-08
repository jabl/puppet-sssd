# == Class: sssd
#
# Installs and configures sssd with AD authentication.
#
# Note that for a fully working solution you need compatible modules
# for configuring pam, nss, krb5, and samba/winbind (for joining the
# domain).
#
# === Parameters
#
# [debug_level]
#   Optional variable specifying the sssd debug level. See the sssd man page for details.
#
# [ad_domains]
#   A nested hash, first one is keyed by realms, the inner ones
#   contain parameters for that realm. The "enumerate" parameter is
#   optional, all others mandatory.
#
# === Examples
#
#  class { '::sssd':
#        debug_level => '0x0070',
#        ad_domains => {
#                'REALM.EXAMPLE.COM' => {
#                          krb5_servers     => ['dc1.realm.example.com', 'dc2.realm.example.com'],
#                          krb5_kpasswd     => 'dc1.realm.example.com',
#                          enumerate        => 'true',
#                          ldap_search_base => 'dc=realm,dc=example,dc=com',
#                          ldap_uris        => ['ldap://dc1.realm.example.com', 'ldap://dc2.realm.example.com']
#                       }
#        }
#  }
#
# === Authors
#
# Janne Blomqvist <janne.blomqvist@aalto.fi>
#
# === Copyright
#
# Copyright 2013 Janne Blomqvist
#
class sssd (
  $config            = $sssd::params::config,
  $config_template   = $sssd::params::config_template,
  $package_ensure    = $sssd::params::package_ensure,
  $package_list      = $sssd::params::package_list,
  $service_enable    = $sssd::params::service_enable,
  $service_ensure    = $sssd::params::service_ensure,
  $service_manage    = $sssd::params::service_manage,
  $service_name      = $sssd::params::service_name,
  $debug_level       = undef,
  $override_homedir  = undef,
  $ad_domains,
  ) inherits sssd::params {

    include '::sssd::install'
    include '::sssd::config'
    include '::sssd::service'

    # Anchor this as per #8040 - this ensures that classes won't float off and
    # mess everything up.  You can read about this at:
    # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
    anchor { 'sssd::begin': }
    anchor { 'sssd::end': }

    Anchor['sssd::begin'] -> Class['::sssd::install'] -> Class['::sssd::config']
    ~> Class['::sssd::service'] -> Anchor['sssd::end']

}
