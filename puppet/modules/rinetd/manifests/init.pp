class rinetd(
    $ports = {
        "80" => "3000"
    }
) {

  file { "rinetd_conffile":
      ensure => file
    , path => "/etc/rinetd.conf"
    , content => template("${module_name}/rinetd.conf.erb")
    , owner => "root"
    , group => "root"
  }
  
  package { "rinetd":
      ensure => installed
    , require => File['rinetd_conffile']
  }
  
  service { "rinetd":
      ensure => running
    , require => [ Package['rinetd'] ]
  }
}