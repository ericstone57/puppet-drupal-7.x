class mysql {
  package {
    ['mysql-common', 'mysql-client', 'mysql-server']:
      ensure => present,
      require => Exec['apt-update'];
  }

  service {
    'mysql':
      enable  => true,
      ensure  => running,
      require => Package['mysql-server']
  }

  file {
    '/etc/mysql/my.cnf':
      source  => 'puppet:///modules/mysql/my.cnf',
      # mode set as 0400 is must for windows environment, otherwise will get file permission error when mysql start
      mode    => 0400,
      require => Package['mysql-server'],
      notify  => Service['mysql'];
  }
}
