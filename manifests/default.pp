Exec {
  path => '/usr/bin:/bin:/usr/local/bin',
}

stage { 'bootstrap':
  before => Stage['main'],
}

class add_repos {
  class { 'apt': }

  exec { 'apt-get update':
    command => 'apt-get update',
  }

  package { 'python-software-properties':
    ensure => installed,
    require => Exec['apt-get update'],
  }

  apt::ppa { 'ppa:chris-lea/node.js':
    require => Package['python-software-properties'],
  }

  apt::ppa { 'ppa:chris-lea/redis-server':
    require => Package['python-software-properties'],
  }

  apt::source { 'mongodb':
    location => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
    release => 'dist',
    repos => '10gen',
    key => '7F0CEB10',
    key_server => 'keyserver.ubuntu.com',
    include_src => false,
  }
}

class nodejs {
  package { 'nodejs':
    ensure => latest,
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
  package { 'redis-server':
    ensure => latest,
  }
}

class mongodb {
  package { 'mongodb-10gen':
    ensure => installed,
  }
}

class { 'add_repos':
  stage => bootstrap,
}

class { 'nodejs': }
class { 'redis': }
class { 'mongodb': }
class { 'nodejs_modules': 
  require => Class['nodejs'],
}
