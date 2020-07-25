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

  desc 'Docker build Ruby 2.7.x environment'
  task :ruby27 do
    DockerTask.pull('ruby:2.7.1')
    c = DockerTask.containers['furynix.ruby27']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Ruby 2.6.x environment'
  task :ruby26 do
    DockerTask.pull('ruby:2.6.6')
    c = DockerTask.containers['furynix.ruby26']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end

  desc 'Docker build Ruby 1.9.x environment'
  task :ruby19 do
    DockerTask.pull('ruby:1.9.3')
    c = DockerTask.containers['furynix.ruby19']
    c.build(no_cache: true)

    unless ENV['NOPUSH']
      c.push
    end
  end
end
