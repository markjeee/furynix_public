require 'bundler'

Bundler.setup
$:.unshift File.expand_path('../lib', __FILE__)

require 'fileutils'
require 'rspec/core/rake_task'
require 'docker_task'
require 'parallel_tests/tasks'
require 'furynix'
require 'dotenv/load'

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

  desc 'Prepare a new account for testing'
  task :prepare_account do
    furynix_user = ENV['FURYNIX_USER']
    furynix_api_token = ENV['FURYNIX_API_TOKEN']

    puts 'For account: %s' % furynix_user
    puts 'Using token: %s' % furynix_api_token

    fixtures_path = File.expand_path('../spec/fixtures', __FILE__)

    packages = [ { name: 'gemfury',
                   version: '0.11.0',
                   kind: 'deb',
                   file: 'gemfury_0.11.0_all.deb',
                   pub: false
                 },
                 { name: 'gemfury',
                   version: '0.11.0-1',
                   kind: 'rpm',
                   file: 'gemfury_0.11.0_all.rpm',
                   pub: false
                 },
                 { name: 'gemfury',
                   version: '0.11.0',
                   kind: 'ruby',
                   file: 'gemfury-0.11.0.gem',
                   pub: false
                 },
                 { name: 'gem_using_bundler',
                   version: '0.1.0',
                   kind: 'ruby',
                   file: 'gem_using_bundler-0.1.0.gem',
                   pub: true
                 },
                 { name: 'Gemfury.DotNetWorld',
                   version: '1.0.0',
                   kind: 'nuget',
                   file: 'Gemfury.DotNetWorld.1.0.0.nupkg',
                   pub: false
                 },
                 { name: 'git.fury.io/furynix/jgo',
                   version: '1.0.0',
                   kind: 'go',
                   file: 'jgo-1.0.0.tgz',
                   pub: false
                 }
               ]

    client = Furynix::GemfuryAPI.client(:user_api_key => furynix_api_token)
    client.account = furynix_user

    packages.each do |package|
      package_path = File.join(fixtures_path, package[:file])

      if File.exist?(package_path)
        matched = false

        begin
          versions = client.versions('%s:%s' % [ package[:kind], package[:name] ])
          matched = versions.detect { |i| i['version'] == package[:version] }
        rescue Gemfury::NotFound
        end

        unless matched
          puts 'Uploading %s:%s => %s' % [ package[:kind], package[:name], furynix_user ]

          case package[:kind]
          when 'go'
            tmp_path = File.expand_path('../tmp', __FILE__)
            working_path = File.join(tmp_path, '%s-%s' % [ package[:name], package[:version] ])
            FileUtils.mkdir_p(working_path)

            bash_script = <<EOF
#!/bin/bash

cd #{working_path}
tar -vxzf #{package_path}
git remote add fury https://git.fury.io/#{furynix_user}/jgo.git
git tag v#{package[:version]}
git push -f fury tags/v#{package[:version]}
git push -f fury master

EOF
            script_path = File.join(working_path, 'apply')
            File.write(script_path, bash_script)
            system('bash %s' % script_path)
          else
            f = File.new(package_path)
            begin
              client.push_gem(f, { :public => package[:pub],
                                   :params => { :as => furynix_user } })
            rescue Gemfury::DupeVersion
              puts 'WARN Package %s already exist' % package[:name]
            ensure
              f.close
            end
          end
        else
          puts 'WARN Package %s of kind %s with v%s already exist' % [ package[:name],
                                                                       package[:kind],
                                                                       package[:version] ]
        end
      else
        puts 'ERR File does not exist: %s' % package_path
      end
    end
  end

  desc 'Clear all packages and git repos in the account'
  task :reset_account do
    furynix_user = ENV['FURYNIX_USER']
    furynix_api_token = ENV['FURYNIX_API_TOKEN']

    puts 'For account: %s' % furynix_user
    puts 'Using token: %s' % furynix_api_token

    client = Furynix::GemfuryAPI.client(:user_api_key => furynix_api_token)
    client.account = furynix_user

    packages = client.list
    packages.each do |p|
      puts 'Found %s:%s' % [ p['language'], p['name'] ]

      versions = client.versions('%s:%s' % [ p['language'], p['name'] ])
      versions.each do |v|
        puts '  YANK: %s' % v['version']
        client.yank_version('%s:%s' % [ p['language'], p['name'] ], v['version'])
      end
    end

    repos = client.git_repos
    repos['repos'].each do |r|
      puts 'Deleting %s repo' % r['name']
      client.git_reset(r['name'])
    end
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
