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
  package { 'nodemon':
    ensure => present,
    provider => npm,
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

class { 'redis':
  version => '2.6.14',
}

class { 'nodejs':
  node_ver => 'v0.10.18',
}

class { 'apt': }
class { 'ppa': }
class { 'mongodb': }
class { 'nodejs_modules': 
  require => Class['nodejs'],
}
