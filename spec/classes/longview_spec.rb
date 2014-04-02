require 'spec_helper'

describe 'longview', :type => :class do

  context "on Ubuntu precise" do

    let(:facts) do
      { :operatingsystem => 'ubuntu', :lsbdistcodename => 'precise' }
    end

    context "with api_key => hi" do

      let(:params) { { :api_key => 'hi' } }

      it { should contain_class('longview::dependencies') }

      it do
        should contain_file('/etc/linode/').with({
          'ensure' => 'directory',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
        })
      end

      it {
        should contain_file('/etc/linode/longview.key').with({
          'ensure'  => 'present',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0600',
          'notify'  => 'Service[longview]',
          'require' => 'File[/etc/linode/]',
        })
      }

      it { should contain_file('/etc/linode/longview.key').with_content(%r(^hi$)) }

      it {
        should contain_package('linode-longview').with({
          'ensure'  => 'latest',
          'notify'  => 'Service[longview]',
          'require' => 'File[/etc/linode/longview.key]',
        })
      }

      it {
        should contain_service('longview').with({
          'ensure'     => 'running',
          'enable'     => 'true',
          'hasrestart' => 'true',
          'require'    => 'Package[linode-longview]',
        })
      }

    end

    context "without api_key" do

      let(:params) { { } }

      it do
        expect { subject }.to raise_error(Puppet::Error, /Must pass api_key to/)
      end

    end

  end

end
