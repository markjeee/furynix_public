require 'bundler'

Bundler.setup
$:.unshift File.expand_path('../lib', __FILE__)

FURYNIX_PUBLIC_PATH = File.expand_path('../', __FILE__)

require 'fileutils'
require 'rspec/core/rake_task'
require 'docker_task'
require 'parallel_tests/tasks'
require 'furynix'
require 'dotenv/load'

DockerTask.load_containers

Rake.add_rakelib 'rakelib'

task :default do; warn 'Please specify the specific specs to run (see: `rake -T`)'; end

namespace :bash do
  desc 'Bash to ruby26 environment'
  task :ruby26 do
    c = DockerTask.containers['furynix.ruby26']
    c.pull
    c.runi
  end

  desc 'Bash to ruby19 environment'
  task :ruby19 do
    c = DockerTask.containers['furynix.ruby19']
    c.pull
    c.runi
  end

  desc 'Bash to bionic environment'
  task :bionic do
    c = DockerTask.containers['furynix.bionic']
    c.pull
    c.runi
  end

  desc 'Bash to CentOS 7 environment'
  task :centos7 do
    c = DockerTask.containers['furynix.centos7']
    c.pull
    c.runi
  end

  desc 'Bash to Linuxbrew environment'
  task :linuxbrew do
    c = DockerTask.containers['furynix.linuxbrew']
    c.pull
    c.runi
  end

  desc 'Bash to buster environment'
  task :buster do
    c = DockerTask.containers['furynix.buster']
    c.pull
    c.runi
  end

  desc 'Bash to Dotnet environment'
  task :dotnet do
    c = DockerTask.containers['furynix.dotnet']
    c.pull
    c.runi
  end

  desc 'Bash to Gradle environment'
  task :gradle do
    c = DockerTask.containers['furynix.gradle']
    c.pull
    c.runi
  end

  desc 'Bash to Go environment'
  task :go do
    c = DockerTask.containers['furynix.go']
    c.pull
    c.runi
  end
end

namespace :vagrant do
  desc 'Rake on GCP instance'
  task :gcp_rake do
    sh "vagrant ssh -c \"cd /furynix; rake\" gcp"
  end

  desc 'Rake on GCP instance (parallel: 3)'
  task :gcp_rake3 do
    sh "vagrant ssh -c \"cd /furynix; rake parallel:spec[3]\" gcp"
  end

  desc 'Rake on AWS instance'
  task :aws_rake do
    sh "vagrant ssh -c \"cd /furynix; rake\" aws"
  end

  desc 'Rake on AWS instance (parallel: 3)'
  task :aws_rake3 do
    sh "vagrant ssh -c \"cd /furynix; rake parallel:spec[3]\" aws"
  end

  desc 'Rake on mark-qnuc instance'
  task :qnuc_rake do
    sh "vagrant ssh -c \"cd /opt/furynix; rake\" mark-qnuc"
  end

  desc 'Rake on AWS instance (parallel: 3)'
  task :qnuc_rake3 do
    sh "vagrant ssh -c \"cd /opt/furynix; rake parallel:spec[3]\" mark-qnuc"
  end
end

namespace :build do
  desc 'Docker build CentOS 8 environment'
  task :centos8 do
    DockerTask.pull('centos:8')
    c = DockerTask.containers['furynix.centos8']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build CentOS 7 environment'
  task :centos7 do
    DockerTask.pull('centos:7')
    c = DockerTask.containers['furynix.centos7']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Fedora 31 environment'
  task :fedora31 do
    DockerTask.pull('fedora:31')
    c = DockerTask.containers['furynix.fedora31']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Focal environment'
  task :focal do
    DockerTask.pull('ubuntu:focal')
    c = DockerTask.containers['furynix.focal']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Bionic environment'
  task :bionic do
    DockerTask.pull('ubuntu:bionic')
    c = DockerTask.containers['furynix.bionic']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Buster environment'
  task :buster do
    DockerTask.pull('debian:buster')
    c = DockerTask.containers['furynix.buster']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Linuxbrew environment'
  task :linuxbrew do
    DockerTask.pull('linuxbrew/brew:latest')
    c = DockerTask.containers['furynix.linuxbrew']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Dotnet environment'
  task :dotnet do
    DockerTask.pull('mcr.microsoft.com/dotnet/core/sdk:2.1')
    c = DockerTask.containers['furynix.dotnet']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Gradle environment'
  task :gradle do
    DockerTask.pull('gradle:6.5')
    c = DockerTask.containers['furynix.gradle']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Maven environment'
  task :maven do
    DockerTask.pull('maven:3.6.3')
    c = DockerTask.containers['furynix.maven']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Go environment'
  task :go do
    DockerTask.pull('golang:1.13.5')
    c = DockerTask.containers['furynix.go']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end
end
