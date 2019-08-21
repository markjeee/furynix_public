module FurynixSpec
  def self.define_docker_containers
    docker_run = lambda do |task, opts|
      opts << '-v %s:/build' % File.expand_path('../../../', __FILE__)
      opts
    end

    if ENV['DEBUG']
      show_commands = true
      shhh = false
    else
      show_commands = ENV['SHOW_COMMANDS'] ? true : false
      shhh = ENV['NO_SHHH'] ? false : true
    end

    DockerTask.create!({ :remote_repo => 'ruby',
                         :pull_tag => '2.6.3',
                         :image_name => 'furynix-spec.ruby263',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'ruby',
                         :pull_tag => '2.6.2',
                         :image_name => 'furynix-spec.ruby262',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'ruby',
                         :pull_tag => '2.5.5',
                         :image_name => 'furynix-spec.ruby255',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'ruby',
                         :pull_tag => '2.5.3',
                         :image_name => 'furynix-spec.ruby253',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })


    DockerTask.create!({ :remote_repo => 'ruby',
                         :pull_tag => '2.4.6',
                         :image_name => 'furynix-spec.ruby246',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'ruby',
                         :pull_tag => '2.4.5',
                         :image_name => 'furynix-spec.ruby245',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'ruby',
                         :pull_tag => '2.3.8',
                         :image_name => 'furynix-spec.ruby238',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'ruby',
                         :pull_tag => '1.9.3',
                         :image_name => 'furynix-spec.ruby193',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'ubuntu',
                         :pull_tag => 'bionic',
                         :image_name => 'furynix-spec.bionic',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'ubuntu',
                         :pull_tag => 'xenial',
                         :image_name => 'furynix-spec.xenial',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'ubuntu',
                         :pull_tag => 'trusty',
                         :image_name => 'furynix-spec.trusty',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'debian',
                         :pull_tag => 'jessie',
                         :image_name => 'furynix-spec.jessie',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'debian',
                         :pull_tag => 'stretch',
                         :image_name => 'furynix-spec.stretch',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'debian',
                         :pull_tag => 'wheezy',
                         :image_name => 'furynix-spec.wheezy',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'centos',
                         :pull_tag => '7',
                         :image_name => 'furynix-spec.centos7',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'fedora',
                         :pull_tag => '29',
                         :image_name => 'furynix-spec.fedora29',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'fedora',
                         :pull_tag => '27',
                         :image_name => 'furynix-spec.fedora27',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'fedora',
                         :pull_tag => '23',
                         :image_name => 'furynix-spec.fedora23',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'linuxbrew/linuxbrew',
                         :pull_tag => '1.9.3',
                         :image_name => 'furynix-spec.linuxbrew',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'mcr.microsoft.com/dotnet/core/sdk',
                         :pull_tag => '2.1',
                         :image_name => 'furynix-spec.dotnet',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })

    DockerTask.create!({ :remote_repo => 'node',
                         :pull_tag => '11.9-stretch',
                         :image_name => 'furynix-spec.node119',
                         :run => docker_run,
                         :show_commands => show_commands,
                         :shhh => shhh
                       })
  end
end

FurynixSpec.define_docker_containers
