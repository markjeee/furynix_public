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
require 'digest'

DockerTask.load_containers

Rake.add_rakelib 'rakelib'

task :default do; warn 'Please specify the specific specs to run (see: `rake -T`)'; end
