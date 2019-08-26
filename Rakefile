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
                  'spec/specs/rubygems_app_using_gem_spec.rb',
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

  desc 'CLI specs (on ubuntu/bionic)'
  RSpec::Core::RakeTask.new('cli') do |t|
    t.pattern = [ 'spec/specs/cli_spec.rb' ]
  end

  desc 'API specs (using gemfury gem client)'
  RSpec::Core::RakeTask.new('api') do |t|
    t.pattern = [ 'spec/specs/gemfury_api_spec.rb',
                  'spec/specs/curl_spec.rb' ]
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

  desc 'Bash to wheezy environment'
  task :wheezy do
    c = DockerTask.containers['furynix.wheezy']
    c.pull
    c.runi
  end

  desc 'Bash to Dotnet environment'
  task :dotnet do
    c = DockerTask.containers['furynix.dotnet']
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
