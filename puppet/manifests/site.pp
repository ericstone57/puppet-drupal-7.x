import 'settings'

Exec { path => "/usr/sbin/:/sbin:/usr/bin:/bin" }
File { owner => $user, group => $group }

node 'default' {
  include apt
  include nginx
  include php
  include memcache
  include mysql
  include drush
}
