# -*- mode: ruby -*-
# vi: set ft=ruby :

HOSTNAME='furynix'

Vagrant.configure("2") do |config|
  config.env.enable

  # Disable NFS functions, to avoid Vagrant NFS weirdos
  config.nfs.functional = false
  config.vm.hostname = HOSTNAME

  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vbguest.auto_update = true
  config.vbguest.no_remote = true

  config.vm.define 'ubuntu', :primary => true do |c|
    c.vm.box = 'ubuntu/bionic64'

    c.vm.hostname = '%s-ubuntu' % config.vm.hostname
    c.vm.synced_folder '.', '/furynix'

    c.vm.provision 'shell',
                   path: File.expand_path('../bin/support/vagrant_provision', __FILE__),
                   keep_color: true,
                   privileged: false
  end

  config.vm.define 'managed' do |c|
    c.vm.box = 'tknerr/managed-server-dummy'

    c.vm.provider :managed do |managed, override|
      override.ssh.host = ENV['FURYNIX_MANAGED_SSH_HOST']
      override.ssh.port = ENV['FURYNIX_MANAGED_SSH_PORT']
      override.ssh.username = ENV['FURYNIX_MANAGED_SSH_USERNAME']
      override.ssh.private_key_path = File.expand_path(ENV['FURYNIX_MANAGED_SSH_PKEY'])

      managed.server = ENV['FURYNIX_MANAGED_SERVER']
    end

    c.vm.provision 'shell',
                   path: File.expand_path('../bin/support/managed_provision', __FILE__),
                   keep_color: true,
                   privileged: false

    c.vm.synced_folder '.', '/opt/furynix', type: 'rsync'
  end unless ENV['FURYNIX_MANAGED_SERVER'].nil? || ENV['FURYNIX_MANAGED_SERVER'].empty?
end
