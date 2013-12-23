Exec {
    path => '/usr/bin:/bin:/usr/local/bin'
}

$apps = {
    "my-app" => {
        dir => "/var/node/my-app"
      , path => "/var/node/my-app/app.js"
      , env => "development"
      , port => "3000"
      , domain => "my-app.localdomain"
    }
}

class ppa {
  exec { 'apt-get update':
      command => 'apt-get update'
  }

  package { 'python-software-properties':
      ensure => installed
    , require => Exec['apt-get update']
  }
}

class nodejs_modules {
  package { 'forever':
      ensure => present
    , provider => npm
  }

  package { 'bower':
      ensure => present
    , provider => npm
  }

  package { 'grunt-cli':
      ensure => present
    , provider => npm
  }
  package { 'nodemon':
      ensure => present
    , provider => npm
  }
}

class mongodb {
  apt::source { 'mongodb':
      location => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart'
    , release => 'dist'
    , repos => '10gen'
    , key => '7F0CEB10'
    , key_server => 'keyserver.ubuntu.com'
    , include_src => false
  }
  
  package { 'mongodb-10gen':
      ensure => installed
    , require => Apt::Source['mongodb']
  }
}


class { 'redis':
    version => '2.8.3'
}

class { 'nodejs':
    node_ver => 'v0.10.24'
}

class { 'apt': }

class { 'ppa': }

class { 'mongodb': 
    require => Class['ppa']
}

class { 'nodejs_modules': 
    require => Class['nodejs']
}

# If you want to use rinetd uncomment the following.
# Please remember to comment out nginx, as they bind to the same ports!
#
# class { 'rinetd':
#     ports => {
#         "80" => "3080"
#       , "443" => "3443"
#     }
# }

class { 'nginx':
    apps => $apps
}

class { 'supervisor':
    apps => $apps
  , require => Class['nodejs']
}