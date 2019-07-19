require 'bundler'
require 'pp'

ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)
Bundler.setup

$:.unshift File.expand_path('../../lib', __FILE__)
require 'furynix'
require 'docker_task'
require 'rspec'
require 'dotenv/load'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

module FurynixSpec
  UNIQ_ID = '%s.%s' % [ sprintf("%20.10f", Time.now.to_f).delete('.').to_i.to_s(36), $$ ]
  TMP_PATH = File.expand_path('../../tmp/spec/%s' % UNIQ_ID, __FILE__)

  def self.gemfury_client
    Furynix::GemfuryAPI.client(:user_api_key => ENV['FURYNIX_API_TOKEN'])
  end

  def self.current_gemfury_version
    '0.10.0'
  end

  def self.current_gemfury_dev_version
    '0.10.0'
  end

  def self.skip_if_only_one
    ENV['ONLY_ONE'] == '1'
  end

  def self.include_all_systems
    ENV['ALL_SYSTEMS'] == '1'
  end

  def self.include_all_ruby
    ENV['ALL_RUBY'] == '1'
  end

  def self.prepare
    FileUtils.mkpath(tmp_path)
    FileUtils.chmod("ugo=rwx", tmp_path)
  end

  def self.tmp_path(fname = nil)
    if fname.nil?
      TMP_PATH
    else
      File.join(tmp_path, fname)
    end
  end

  def self.prepare_docker_outfile
    if defined?(@@outfile_counter)
      @@outfile_counter += 1
    else
      @@outfile_counter = 1
    end

    f = FurynixSpec.tmp_path('docker.out.%d' % @@outfile_counter)
    FileUtils.rm_f(f) if File.exists?(f)
    f
  end

  def self.calculate_build_path(file_path)
    root_path = File.expand_path('../../', __FILE__)
    file_path.gsub(root_path, '/build')
  end
end

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
