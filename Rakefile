require 'bundler'

Bundler.setup
$:.unshift File.expand_path('../lib', __FILE__)

require 'rspec/core/rake_task'
require 'docker_task'
require 'parallel_tests/tasks'
require 'furynix'

DockerTask.load_containers

task :default do; warn 'Please specify the specific specs to run (see: `rake -T`)'; end

namespace :spec do
  desc 'Run all specs (caution: all specs can take up to an hour)'
  RSpec::Core::RakeTask.new('all')

  desc 'APT, install specs'
  RSpec::Core::RakeTask.new('apt_install') do |t|
    t.pattern = [ 'spec/specs/apt_install_gemfury_spec.rb' ]
  end

  desc 'YUM, install specs'
  RSpec::Core::RakeTask.new('yum_install') do |t|
    t.pattern = [ 'spec/specs/yum_install_gemfury_spec.rb' ]
  end

  desc 'Brew, install specs'
  RSpec::Core::RakeTask.new('brew_install') do |t|
    t.pattern = [ 'spec/specs/brew_install_gemfury_spec.rb' ]
  end

  desc 'Rubygem, gem install, gem use, push gem'
  RSpec::Core::RakeTask.new('rubygems') do |t|
    t.pattern = [ 'spec/specs/rubygems_gem_using_bundler_spec.rb',
                  'spec/specs/rubygems_install_gemfury_spec.rb'
                ]
  end

  desc 'NPM, module use'
  RSpec::Core::RakeTask.new('npm_module_use') do |t|
    t.pattern = [ 'spec/specs/npm_module_using_npm_spec.rb' ]
  end

  desc 'Dotnet, build, push'
  RSpec::Core::RakeTask.new('dotnet_build') do |t|
    t.pattern = [ 'spec/specs/dotnet_build_spec.rb' ]
  end

  desc 'Maven, build, build'
  RSpec::Core::RakeTask.new('maven_build') do |t|
    t.pattern = [ 'spec/specs/maven_build_spec.rb',
                  'spec/specs/gradle_build_spec.rb' ]
  end

  desc 'Go, build, push'
  RSpec::Core::RakeTask.new('go_build') do |t|
    t.pattern = [ 'spec/specs/go_build_spec.rb' ]
  end

  desc 'CLI specs (on ubuntu/bionic)'
  RSpec::Core::RakeTask.new('cli') do |t|
    t.pattern = [ 'spec/specs/cli_spec.rb' ]
  end

  desc 'API specs using gemfury gem client'
  RSpec::Core::RakeTask.new('api') do |t|
    t.pattern = [ 'spec/specs/api_spec.rb' ]
  end

  desc 'Curl specs'
  RSpec::Core::RakeTask.new('curl_api') do |t|
    t.pattern = [ 'spec/specs/curl_spec.rb',
                  'spec/specs/curl_accounts_spec.rb',
                  'spec/specs/curl_gems_spec.rb',
                  'spec/specs/curl_versions_spec.rb',
                  'spec/specs/curl_repos_spec.rb',
                  'spec/specs/curl_collaborators_spec.rb',
                  'spec/specs/curl_add_remove_collaborator_spec.rb'
                ]
  end
end

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
  desc 'Docker build CentOS 7 environment'
  task :centos7 do
    DockerTask.pull('centos:7')
    c = DockerTask.containers['furynix.centos7']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Fedora 29 environment'
  task :fedora29 do
    DockerTask.pull('fedora:29')
    c = DockerTask.containers['furynix.fedora29']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Bionic environment'
  task :bionic do
    DockerTask.pull('ubuntu:bionic')
    c = DockerTask.containers['furynix.bionic']
    c.build

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Buster environment'
  task :buster do
    DockerTask.pull('debian:buster')
    c = DockerTask.containers['furynix.buster']
    c.build

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Linuxbrew environment'
  task :linuxbrew do
    DockerTask.pull('linuxbrew/brew:latest')
    c = DockerTask.containers['furynix.linuxbrew']
    c.build

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Dotnet environment'
  task :dotnet do
    DockerTask.pull('mcr.microsoft.com/dotnet/core/sdk:2.1')
    c = DockerTask.containers['furynix.dotnet']
    c.build

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Gradle environment'
  task :gradle do
    DockerTask.pull('gradle:6.0.1')
    c = DockerTask.containers['furynix.gradle']
    c.build

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Maven environment'
  task :maven do
    DockerTask.pull('maven:3.6.3')
    c = DockerTask.containers['furynix.maven']
    c.build

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Go environment'
  task :go do
    DockerTask.pull('golang:1.13.5')
    c = DockerTask.containers['furynix.go']
    c.build

    unless ENV['NOPUSH']
      c.push
    end
  end
end
