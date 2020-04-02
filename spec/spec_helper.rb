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

  def self.furynix_source_url(platform)
    'https://%s.fury.io/%s' % [ platform, furynix_user ]
  end

  def self.furynix_push_url
    'https://push.fury.io/%s' % furynix_user
  end

  def self.furynix_user
    ENV['FURYNIX_USER']
  end

  def self.furynix_api_token
    ENV['FURYNIX_API_TOKEN']
  end

  def self.create_exec_args(args)
    {
      'furynix_user' => furynix_user,
      'furynix_token' => furynix_api_token
    }.merge(args)
  end

  def self.create_env_args(env)
    {
      'furynix_user' => furynix_user,
      'furynix_token' => furynix_api_token
    }.merge(env)
  end

  def self.gemfury_latest_version
    self.gemfury_version
  end

  # this is separate, since only have a single Tap repo,
  # and can't publish dev version if not yet synced to
  # the official repo
  def self.gemfury_brew_dev_version
    self.gemfury_version
  end

  def self.gemfury_version
    '0.11.0'
  end

  def self.gemfury_dev_version
    '0.11.1.rc1'
  end

  def self.gemfury_head_version
    v = '0.11.2.head'

    if !ENV['FURYNIX_HEAD_VERSION'].nil? && !ENV['FURYNIX_HEAD_VERSION'].empty?
      v = ENV['FURYNIX_HEAD_VERSION']
    end

    v
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

  def self.spec_path
    File.expand_path('../', __FILE__)
  end

  def self.fixtures_path(fixture = nil)
    if fixture.nil?
      File.join(spec_path, 'fixtures')
    else
      File.join(spec_path, 'fixtures', fixture)
    end
  end

  def self.fixtures_gemfury_gem
    File.join(fixtures_path, 'gemfury-0.11.0.rc1.gem')
  end

  def self.fixtures_gemfury_gem_version
    '0.11.0.rc1'
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

  def self.persist_exec_args(args)
    if defined?(@@execargs_file_counter)
      @@execargs_file_counter += 1
    else
      @@execargs_file_counter = 1
    end

    f = FurynixSpec.tmp_path('docker.exec_args.%d' % @@execargs_file_counter)
    FileUtils.rm_f(f) if File.exists?(f)

    File.open(f, 'w') do |io|
      args.each do |k,v|
        io.puts('export %s=%s' % [ k, v ])
      end
    end

    f
  end

  def self.create_env_file(env)
    if defined?(@@execargs_file_counter)
      @@execargs_file_counter += 1
    else
      @@execargs_file_counter = 1
    end

    f = FurynixSpec.tmp_path('docker.env_args.%d' % @@execargs_file_counter)
    FileUtils.rm_f(f) if File.exists?(f)

    File.open(f, 'w') do |io|
      env.each do |k,v|
        io.puts('%s=%s' % [ k, v ])
      end
    end

    f
  end

  def self.pass_exec_args(args)
    f = persist_exec_args(args)
    calculate_build_path(f)
  end

  def self.calculate_build_path(file_path)
    root_path = File.expand_path('../../', __FILE__)
    file_path.gsub(root_path, '/build')
  end
end

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
