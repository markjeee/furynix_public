namespace :spec do
  desc 'Prepare a new account for testing'
  task :setup_account do
    furynix_user = ENV['FURYNIX_USER']
    furynix_api_token = ENV['FURYNIX_API_TOKEN']

    puts 'For account: %s' % furynix_user
    puts 'Using token: %s' % furynix_api_token

    fixtures_path = File.join(FURYNIX_PUBLIC_PATH, 'spec/fixtures')

    packages = [
                 { name: 'gemfury',
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
                 { name: '@fury/module_using_npm',
                   version: '1.0.0',
                   kind: 'js',
                   file: 'fury-module_using_npm-1.0.0.tgz',
                   pub: false
                 },
                 { name: 'org.furynix/jworld',
                   version: '1.0',
                   kind: 'maven',
                   file: 'jworld-1.0.jar',
                   pub: false
                 },
                 { name: 'org.furynix/nworld',
                   version: '1.0',
                   kind: 'maven',
                   file: 'nworld-1.0.pom',
                   metadata: 'nworld-1.0-maven-metadata.xml',
                   pub: false
                 },
                 { name: 'org.furynix.nworld/jhello',
                   version: '1.0',
                   kind: 'maven',
                   file: 'nworld-jhello-1.0.jar',
                   pub: false
                 },
                 { name: 'org.furynix.nworld/jworld',
                   version: '1.0',
                   kind: 'maven',
                   file: 'nworld-jworld-1.0.jar',
                   pub: false
                 },
                 { name: 'git.fury.io/furynix/jgo',
                   version: '1.0.0',
                   kind: 'go',
                   file: 'jgo-1.0.0.tgz',
                   repo_name: 'jgo',
                   pub: false
                 },
                 { name: 'gem_for_repo',
                   version: '0.1.0',
                   kind: 'ruby',
                   file: 'gem_for_repo.git.tgz',
                   pub: true,
                   git: true
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

          if package[:kind] == 'go' || package[:git] == true
            tmp_path = File.join(FURYNIX_PUBLIC_PATH, 'tmp')
            working_path = File.join(tmp_path, '%s-%s' % [ package[:name], package[:version] ])
            FileUtils.mkdir_p(working_path)

            repo_name = package[:repo_name] || package[:name]

            bash_script = <<EOF
#!/bin/bash

cd #{working_path}
tar -xzf #{package_path}
git remote add fury https://git.fury.io/#{furynix_user}/#{repo_name}.git

git push -f fury --delete v#{package[:version]}; true
git tag v#{package[:version]} master
git push -f fury refs/tags/v#{package[:version]}
sleep 3
git push -f fury master

EOF
            script_path = File.join(working_path, 'apply')
            File.write(script_path, bash_script)
            system('bash %s' % script_path)

            if package[:pub]
              sleep(3)

              client.update_privacy(package[:name], false)
            end
          elsif package[:kind] == 'maven' && package[:file] =~ /^.+\.pom$/
            metadata_path = File.join(fixtures_path, package[:metadata])
            put_endpoint = 'https://push.fury.io'

            f = Faraday.new(url: put_endpoint,
                            headers: { 'user-agent' => 'Apache-Maven/3.6.3 (Furynix mock client)' })
            f.basic_auth(furynix_api_token, '.')

            push_files = [ ]
            push_files << { put_path: File.join('/', furynix_user, package[:name].gsub('.', '/'),
                                                package[:version], package[:file]),
                            put_file: File.read(package_path) }
            push_files << { put_path: File.join('/', furynix_user, package[:name].gsub('.', '/'),
                                                'maven-metadata.xml'),
                            put_file: File.read(metadata_path) }

            push_files.each do |pf|
              put_path = pf[:put_path]
              put_file = pf[:put_file]

              resp = f.put(put_path, put_file)
              unless resp.success?
                error = (resp.body || { })['error'] || { }
                puts 'ERR Put failed: %s - %s' % [ resp.status, error ]
              end
            end
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
  task :clear_account do
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
