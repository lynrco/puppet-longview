class longview::dependencies {

  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/sbin',
  }

  case $::operatingsystem {

    'debian', 'ubuntu': {

      package { 'apt-transport-https':
        ensure => latest,
      }

      file { '/etc/apt/trusted.gpg.d/linode.gpg':
        source => 'puppet:///modules/longview/linode.gpg',
        notify => Exec['add-longview-apt-key'],
      }

      exec { 'add-longview-apt-key':
        command     => 'apt-key add /etc/apt/trusted.gpg.d/linode.gpg',
        refreshonly => true,
      }

      file { '/etc/apt/sources.list.d/longview.list':
        ensure  => present,
        content => template('longview/apt_source.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => [ Package['apt-transport-https'],
                     File['/etc/apt/trusted.gpg.d/linode.gpg']],
      }

      exec { 'apt-update':
        command     => 'apt-get update',
        refreshonly => true,
      }

    }

    default: {
      fail('Platform not supported by Longview module. Patches welcome.')
    }

  }

}
