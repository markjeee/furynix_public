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
    c.vm.network 'private_network', ip: '10.100.0.35'

    c.vm.synced_folder '.', '/furynix'

    c.vm.provision 'shell',
                   path: File.expand_path('../bin/support/vagrant_provision', __FILE__),
                   keep_color: true,
                   privileged: false
  end

  config.vm.define 'debian' do |c|
    c.vm.box = 'debian/stretch64'

    c.vm.hostname = '%s-debian' % config.vm.hostname
    c.vm.network 'private_network', ip: '10.100.0.36'

    c.vm.synced_folder '.', '/furynix'
  end

  config.vm.define 'centos7' do |c|
    c.vm.box = 'centos/7'

    c.vm.hostname = '%s-centos7' % config.vm.hostname
    c.vm.network 'private_network', ip: '10.100.0.37'

    c.vm.synced_folder '.', '/furynix'
  end

  config.vm.define 'fedora' do |c|
    c.vm.box = 'fedora/30-cloud-base'

    c.vm.hostname = '%s-fedora' % config.vm.hostname
    c.vm.network 'private_network', ip: '10.100.0.38'

    c.vm.synced_folder '.', '/furynix'
  end

  config.vm.define 'gcp' do |c|
    c.vm.box = 'google/gce'

    c.vm.provider :google do |google, override|
      google.google_project_id = ENV['FURYNIX_GCP_PROJECT']
      google.google_json_key_location = File.expand_path(ENV['FURYNIX_GCP_JSON_KEY'])

      google.name = '%s-gcp' % HOSTNAME
      google.tags = [ HOSTNAME, 'fw-allow-ssh' ]

      google.image_family = 'ubuntu-1804-lts'
      google.machine_type = 'g1-small'
      google.zone = 'asia-southeast1-a'
      google.network = 'default'
      google.can_ip_forward = true

      override.ssh.username = ENV['FURYNIX_GCP_SSH_USERNAME']
      override.ssh.private_key_path = File.expand_path(ENV['FURYNIX_GCP_SSH_PKEY'])
    end

    c.vm.provision 'shell',
                   path: File.expand_path('../bin/support/vagrant_provision', __FILE__),
                   keep_color: true,
                   privileged: false

    c.vm.synced_folder '.', '/furynix', type: 'rsync'
  end unless ENV['FURYNIX_GCP_PROJECT'].nil? || ENV['FURYNIX_GCP_PROJECT'].empty?

  config.vm.define 'aws' do |c|
    c.vm.box = 'aws/dummy'

    c.vm.provider :aws do |aws, override|
      aws.instance_type = 't2.micro'
      aws.keypair_name = ENV['FURYNIX_AWS_KEYPAIR']

      # ubuntu 18.04 ebs-ssd 20190429 ap-southeast-1
      aws.ami = 'ami-0dad20bd1b9c8c004'
      aws.subnet_id = ENV['FURYNIX_AWS_SUBNET']
      aws.security_groups = ENV['FURYNIX_AWS_SECURITY_GROUPS'].split(',')
      aws.associate_public_ip = true

      aws.tags = { 'Name' => '%s-aws' % HOSTNAME }

      override.ssh.username = ENV['FURYNIX_AWS_SSH_USERNAME']
      override.ssh.private_key_path = File.expand_path(ENV['FURYNIX_AWS_SSH_PKEY'])
    end

    c.vm.provision 'shell',
                   path: File.expand_path('../bin/support/vagrant_provision', __FILE__),
                   keep_color: true,
                   privileged: false

    c.vm.synced_folder '.', '/furynix', type: 'rsync'
  end unless ENV['FURYNIX_AWS_KEYPAIR'].nil? || ENV['FURYNIX_AWS_KEYPAIR'].empty?

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
