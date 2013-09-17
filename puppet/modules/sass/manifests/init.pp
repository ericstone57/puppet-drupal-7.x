class sass {
  package {
    'ruby-sass':
      ensure => present,
      require => Exec['apt-update'];
    'ruby-compass':
      ensure => present,
      require => Exec['apt-update'];
  }

  exec {
    'apt-get -uVfy install libfssm-ruby && touch /root/.sass-installed':
      creates => '/root/.sass-installed',
      require => Package['ruby-sass', 'ruby-compass']
  }
}
