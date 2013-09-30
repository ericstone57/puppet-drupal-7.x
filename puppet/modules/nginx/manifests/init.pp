class nginx {
  package {
    'nginx-full':
      ensure => present,
      require => Exec['ppa-add-repo-nginx-stable', 'ppa-add-repo-nginx-custom']
  }

  service {
    'nginx':
      enable  => true,
      ensure  => running,
      require => Package['nginx-full']
  }

  exec {
    'ppa-add-repo-nginx-stable':
      command => 'add-apt-repository -y ppa:nginx/stable',
      creates => '/etc/apt/sources.list.d/nginx-stable-precise.list',
      require => Package['python-software-properties'];
    'ppa-add-repo-nginx-custom':
      command => 'add-apt-repository -y ppa:brianmercer/nginx',
      creates => '/etc/apt/sources.list.d/brianmercer-nginx-precise.list',
      require => Package['python-software-properties'];
    'backup-nginx-conf':
      command => 'cp -r /etc/nginx /etc/nginx.bak',
      creates => '/etc/nginx.bak/nginx.conf',
      require => Package['nginx-full'];
    'enable-site-www-conf':
      command => 'rm -rf * && ln -s ../sites-available/www.conf',
      creates => '/etc/nginx/sites-enabled/www.conf',
      cwd     => '/etc/nginx/sites-enabled',
      user    => 'root',
      require => File['/etc/nginx'];
  }

  file {
    '/etc/nginx':
      ensure       => directory,
      force        => true,
      recurse      => true,
      source       => 'puppet:///modules/nginx/drupal-with-nginx',
      sourceselect => all,
      owner        => 'root',
      group        => 'root',
      require      => Package['nginx-full'],
      notify       => Service['nginx'];
    '/etc/nginx/sites-available/www.conf':
      content  => template("nginx/www-${env}.erb"),
      owner   => 'root',
      group   => 'root',
      require => File['/etc/nginx'],
      notify  => Exec['enable-site-www-conf'];
    '/etc/nginx/nginx.conf':
      content  => template("nginx/nginx-${env}.erb"),
      owner   => 'root',
      group   => 'root',
      require => File['/etc/nginx'],
      notify  => Service['nginx'];
    '/etc/nginx/apps/drupal/drupal.conf':
      content  => template("nginx/drupal-${env}.erb"),
      owner   => 'root',
      group   => 'root',
      require => File['/etc/nginx'],
      notify  => Service['nginx'];
    '/etc/nginx/apps/drupal/drupal_cron_update.conf':
      source  => 'puppet:///modules/nginx/drupal_cron_update.conf',
      owner   => 'root',
      group   => 'root',
      require => File['/etc/nginx'],
      notify  => Service['nginx'];
    '/etc/nginx/apps/drupal/drupal_install.conf':
      source  => 'puppet:///modules/nginx/drupal_install.conf',
      owner   => 'root',
      group   => 'root',
      require => File['/etc/nginx'],
      notify  => Service['nginx'];
    '/etc/nginx/upstream_phpcgi_tcp.conf':
      content  => template("nginx/upstream_phpcgi_tcp-${env}.erb"),
      owner   => 'root',
      group   => 'root',
      require => File['/etc/nginx'],
      notify  => Service['nginx'];
    '/var/cache/nginx':
      ensure => directory,
      owner   => 'root',
      group   => 'root',
      require => File['/etc/nginx/nginx.conf'],
      notify  => Service['nginx'];
  }

}
