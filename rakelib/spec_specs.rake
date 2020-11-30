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
  RSpec::Core::RakeTask.new('npm_install') do |t|
    t.pattern = [ 'spec/specs/npm_install_spec.rb' ]
  end

  desc 'Dotnet, build, push'
  RSpec::Core::RakeTask.new('dotnet_build') do |t|
    t.pattern = [ 'spec/specs/dotnet_build_spec.rb' ]
  end

  desc 'Maven, build, build'
  RSpec::Core::RakeTask.new('maven_build') do |t|
    t.pattern = [ 'spec/specs/maven_build_spec.rb' ]
  end

  desc 'Gradle, build, build'
  RSpec::Core::RakeTask.new('gradle_build') do |t|
    t.pattern = [ 'spec/specs/gradle_build_spec.rb' ]
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
