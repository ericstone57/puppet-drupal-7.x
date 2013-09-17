class redis {
  package {
    'redis-server':
      ensure => present,
      require => Exec['ppa-add-redis']
  }

  service {
    'redis-server':
      enable  => true,
      ensure  => running,
      require => Package['redis-server']
  }

  exec {
    'ppa-add-redis':
      command => 'add-apt-repository -y ppa:rwky/redis',
      creates => '/etc/apt/sources.list.d/rwky-redis.list',
      require => Package['python-software-properties'],
      notify  => Exec['apt-update'];
    'clone phpredis repository':
      command => "git clone https://github.com/nicolasff/phpredis.git; touch /root/.phpredis_clone",
      cwd     => $home,
      creates => '/root/.phpredis_clone',
      require => Package['git'];
    'build phpredis':
      command  => 'phpize; ./configure; make && make install; touch /root/.phpredis',
      cwd      => "$home/phpredis",
      path     => "/usr/bin:/usr/sbin:/bin",
      provider => shell,
      creates  => '/root/.phpredis',
      require  => [Package['redis-server', 'php5-dev'], Exec['clone phpredis repository']],
      notify   => File['/etc/php5/mods-available/redis.ini'];
  }

  file {
    '/etc/php5/mods-available/redis.ini':
      ensure  => present,
      content => "extension=redis.so",
      notify  => File['/etc/php5/conf.d/redis.ini'];
    '/etc/php5/conf.d/redis.ini':
      ensure => link,
      target => '/etc/php5/mods-available/redis.ini',
      notify => Service['php5-fpm'];
  }
}
