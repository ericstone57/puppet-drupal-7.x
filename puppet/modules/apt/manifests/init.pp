class apt {
  # for PPA
  package {
    'python-software-properties':
      ensure  => present,
      require => Exec['apt-update'];
  }
  # use new mirror, faster in China
  file {
    '/etc/apt/sources.list':
      source => 'puppet:///modules/apt/sources.list',
  }
  exec {
    'apt-update':
      #command => 'aptitude -y update && aptitude -y upgrade && touch /root/.apt-update',
      command => 'aptitude -y update && touch /root/.apt-update',
      creates => '/root/.apt-update',
      timeout => 900,
      require => File['/etc/apt/sources.list'],
  }
}
