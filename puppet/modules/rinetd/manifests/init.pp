class rinetd(
    $ports = {
        "80" => "3000"
    }
) {

  package { "rinetd":
      ensure => installed
  }
  
  file { "rinetd_conf":
      ensure => file
    , path => "/etc/rinetd.conf"
    , content => template("${module_name}/rinetd.conf.erb")
    , owner => "root"
    , group => "root"
    . notify => Service['rinetd']
  }
  
  service { "rinetd":
      ensure => running
    , require => Package['rinetd']
  }
}