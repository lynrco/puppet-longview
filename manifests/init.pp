class longview($api_key) {

  if $api_key == undef {
    fail('api_key is required for longview')
  }

  require longview::dependencies

  File {
    group => 'root',
    owner => 'root',
  }

  file { '/etc/linode/':
    ensure => directory,
    mode   => '0755',
  }

  file { '/etc/linode/longview.key':
    ensure  => present,
    content => $api_key,
    mode    => '0600',
    notify  => Service['longview'],
    require => File['/etc/linode/'],
  }

  package { 'linode-longview':
    ensure  => latest,
    require => File['/etc/linode/longview.key'],
  }

  service { 'longview':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['linode-longview'],
  }

}
