Exec {
  path => '/usr/bin:/bin:/usr/local/bin',
}

class ppa {
  exec { 'apt-get update':
    command => 'apt-get update',
  }

  package { 'python-software-properties':
    ensure => installed,
    require => Exec['apt-get update'],
  }
}

class nodejs {
  apt::ppa { 'nodejs':
    name => 'ppa:chris-lea/node.js',
    require => Class['ppa'],
  }

  package { 'nodejs':
    ensure => latest,
    require => Apt::Ppa['nodejs'],
  }
}

class nodejs_modules {
  package { 'forever':
    ensure => present,
    provider => npm,
  }

  package { 'bower':
    ensure => present,
    provider => npm,
  }

  package { 'grunt-cli':
    ensure => present,
    provider => npm,
  }
}

class redis {
  apt::ppa { 'redis-server':
    name => 'ppa:chris-lea/redis-server',
    require => Class['ppa'],
  }

  package { 'redis-server':
    ensure => latest,
    require => Apt::Ppa['redis-server'],
  }


  file { '/etc/redis':
    ensure => directory,
    owner => root,
    group => root,
    before => File['redis.conf'],
  }

  file { 'redis.conf':
    path => '/etc/redis/redis.conf',
    source => 'puppet:///modules/redis/redis.conf',
    owner => root,
    group => root,
    before => Package['redis-server'],
  }

  service { 'redis-server':
    require => Package['redis-server'],
    ensure => running,
  }
}

class mongodb {
  apt::source { 'mongodb':
    location => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
    release => 'dist',
    repos => '10gen',
    key => '7F0CEB10',
    key_server => 'keyserver.ubuntu.com',
    include_src => false,
  }
  
  package { 'mongodb-10gen':
    ensure => installed,
    require => Apt::Source['mongodb'],
  }
}

class { 'apt': }
class { 'ppa': }
class { 'nodejs': }
class { 'redis': }
class { 'mongodb': }
class { 'nodejs_modules': 
  require => Class['nodejs'],
}
