class nginx(
    $port = 3000
) {
  
  package { "ssl-cert":
      ensure => installed
  }
  
  package { "nginx":
      ensure => installed
    , require => Package['ssl-cert']
  }
  
  file { "nginx_conf":
      ensure => file
    , path => "/etc/nginx/sites-available/default"
    , content => template("${module_name}/default.erb")
    , owner => "root"
    , group => "root"
    , require => Package['nginx']
    , notify => Service['nginx']
  }
  
  service { "nginx":
      ensure => running
    , require => Package['nginx']
  }
}