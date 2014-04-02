require 'spec_helper'

describe 'longview::dependencies', :type => :class do

  context 'On Ubuntu' do

    let(:facts) do
      { :operatingsystem => 'ubuntu', :lsbdistcodename => 'precise' }
    end

    it {
      should contain_package('apt-transport-https').with({
        'ensure' => 'latest',
      })
    }

    it {
      should contain_file('/etc/apt/trusted.gpg.d/linode.gpg').with({
        'source' => 'puppet:///modules/longview/linode.gpg',
        'notify' => 'Exec[add-longview-apt-key]',
      })
    }

    it {
      should contain_exec('add-longview-apt-key').with({
        'path'        => '/usr/bin:/usr/sbin:/bin:/sbin',
        'command'     => 'apt-key add /etc/apt/trusted.gpg.d/linode.gpg',
        'refreshonly' => 'true',
      })
    }

    it {
      should contain_file('/etc/apt/sources.list.d/longview.list').with({
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[apt-transport-https]',
                       'File[/etc/apt/trusted.gpg.d/linode.gpg]'],
      })
    }

    it {
      contents = %r(deb https://apt-longview\.linode\.com/ precise main)
      should contain_file('/etc/apt/sources.list.d/longview.list').with_content(contents)
    }

    it {
      should contain_exec('apt-update').with({
        'path'        => '/usr/bin:/usr/sbin:/bin:/sbin',
        'command'     => 'apt-get update',
        'refreshonly' => 'true',
      })
    }

  end

  context "On RedHat" do

    let(:facts) do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '5',
      }
    end

    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, %r(Platform not supported by Longview module. Patches welcome.))
    end

  end

end
