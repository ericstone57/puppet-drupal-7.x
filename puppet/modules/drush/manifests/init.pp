class drush {
  exec {
    'discover-drush-channel':
      command => 'pear channel-discover pear.drush.org && touch /root/.drush-channel-discovered',
      creates => '/root/.drush-channel-discovered',
      user    => 'root',
      require => Package['php-pear'];
    'install-drush':
      command => 'pear install drush/drush && touch /root/.drush-installed',
      creates => '/root/.drush-installed',
      user    => 'root',
      require => Exec['discover-drush-channel'];
    # Drush reply on Console_Table, will download automatically when first run
    'setup-drush':
      command => "drush && mkdir -p .drush/cache && chmod -R 777 .drush && chown -R $user:$group .drush",
      user    => 'root',
      cwd     => $home,
      require => Exec['install-drush'];
  }
}
