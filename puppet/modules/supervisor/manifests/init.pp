class supervisor (
    $apps = {
        "my-app" => {
            dir => "/var/node/my-app"
          , path => "/var/node/my-app/app.js"
          , env => "development"
        }
    }
) {

  $app_keys = keys($apps)

  define config_files($apps) {
    $app = $apps[$title]
    
    file { "supervisor_conf_${title}":
        ensure => file
      , path => "/etc/supervisor/conf.d/node.${title}.conf"
      , content => template("${module_name}/node.erb")
      , owner => "root"
      , group => "root"
    }
  }

  group { "node":
      ensure => present
  }

  user { "node":
      ensure        => present
    , gid           => "node"
    , shell         => "/bin/bash"
    , home          => "/var/node"
    , comment       => "node"
    , require       => Group['node']
  }

  package { "supervisor":
      ensure => installed
  }
  
  package { "node-supervisor":
      name        => "supervisor@0.5.6"
    , ensure      => present
    , provider    => npm
  }

  config_files { $app_keys:
      apps => $apps
    , require => Package['supervisor', 'node-supervisor']
    , notify => Service['supervisor']
  }
  
  service { "supervisor":
      ensure => running
    , require => [ Package['supervisor', 'node-supervisor'], User['node'] ]
  }
}