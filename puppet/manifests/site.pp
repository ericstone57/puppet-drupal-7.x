import 'settings'

Exec { path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" }
File { owner => $user, group => $group }

node 'default' {
  include apt
  include git
  include nginx
  include php
  include memcache
  include mysql
  include drush
  include redis
  #include sass
}
