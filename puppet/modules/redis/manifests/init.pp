class redis(
    $version = '2.4.14'
  , $port = '6379'
) {

  $redis_tar = "redis-$version.tar.gz"
  $redis_dl = "http://redis.googlecode.com/files/$redis_tar"

  if defined(Package['curl']) == false {
    package { "curl":
        ensure => "installed"
    }
  }

  if defined(Package['build-essential']) == false {
    package { "build-essential":
        ensure => "installed"
    }
  }

  group { "redis":
      ensure => present
  }

  user { "redis":
      ensure        => present
    , gid           => "redis"
    , shell         => '/bin/false'
    , comment       => 'redis-server'
    , require       => Group['redis']
  }

  exec { 'download_redis': 
      command       => "curl -o $redis_tar $redis_dl"
    , cwd           => '/tmp'
    , creates       => "/tmp/${redis_tar}"
    , require       => Package['curl']
    , path          => ['/usr/bin/', '/bin/']
  }
  
  exec { 'extract_redis':
      command       => "tar -xzf $redis_tar"
    , cwd           => "/tmp"
    , creates       => "/tmp/redis-${version}"
    , require       => Exec['download_redis']
    , path          => ['/usr/bin/', '/bin/']
  }

  file { "/tmp/redis-$version":
      ensure        => 'directory'
    , require       => Exec['extract_redis']
  }

  exec { 'install_redis':
      command       => 'make install'
    , cwd           => "/tmp/redis-${version}"
    , require       => [  File["/tmp/redis-${version}"]
                        , Package['build-essential']
                        , User['redis'] ]
    , timeout       => 0
    , path          => [ '/usr/bin', '/bin', '/usr/local/bin' ]
    , unless        => "which redis-server"
  }

  file { 'redis_confdir':
      ensure    => directory
    , path      => "/etc/redis"
    , owner     => "root"
    , group     => "root"
  }

  file { 'redis_logdir':
      ensure    => directory
    , path      => "/var/log/redis"
    , require   => User['redis']
    , owner     => "redis"
    , group     => "redis"
  }

  file { 'redis_libdir':
      ensure    => directory
    , path      => "/var/lib/redis"
    , require   => User['redis']
    , owner     => "redis"
    , group     => "redis"
  }

  file { 'redis_logfile':
      ensure    => file
    , path      => "/var/log/redis/${port}.log"
    , require   => [ File['redis_logdir'], User['redis'] ]
    , group     => "redis"
    , owner     => "redis"
  }

  file { 'redis_conffile': 
      ensure    => file
    , path      => "/etc/redis/${port}.conf"
    , content   => template("${module_name}/redis.conf.erb")
    , require   => File['redis_confdir']
  }

  file { 'redis_upstart': 
      ensure    => file
    , path      => "/etc/init/redis-server-${port}.conf"
    , content   => template("${module_name}/redis.upstart.erb")
    , owner     => "root"
    , group     => "root"
  }

  service { "redis-server-${port}":
      ensure    => running
    , require   => [ User['redis'], File['redis_upstart', 'redis_conffile', 'redis_logfile', 'redis_libdir'] ]
  }
}
