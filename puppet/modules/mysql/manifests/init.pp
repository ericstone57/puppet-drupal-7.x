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

  if $env == 'dev' {
    exec {
      'mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO \'root\'@\'%\' WITH GRANT OPTION;FLUSH PRIVILEGES;" && touch /root/.mysql_granted':
        creates => '/root/.mysql_granted',
        require => [Package['mysql-server', 'mysql-client'], File['/etc/mysql/my.cnf']]
    }
  }
}
