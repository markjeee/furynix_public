require_relative '../spec_helper'

describe 'Go' do
  shared_examples 'build and push' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client

      @package_name = 'git.fury.io/furynix/jgo'
      @package_version = '1.1.0'

      @goproxy = 'https://%s@go-proxy.fury.io/%s/' % [ FurynixSpec.furynix_api_token,
                                                       FurynixSpec.furynix_user ]
      @goprivate = 'git.fury.io/furynix/*'
      @gonoproxy = 'none'
    end

    it 'should build and push' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'package_name' => @package_name,
                                'package_version' => @package_version,
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path),
                                'GOPROXY' => @goproxy,
                                'GOPRIVATE' => @goprivate,
                                'GONOPROXY' => @gonoproxy
                              })

      ret = container.run(:exec => '/build/spec/exec/go_build_jgo',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))

      expect(ret).to be_a_docker_success

      versions = @fury.versions(@package_name)
      expect(versions.collect { |i| i['version'] }).to include(@package_version)
    end

    after do
      begin
        @fury.yank_version(@package_name, @package_version)
      rescue Gemfury::NotFound
      end

      # remove auto-ver packages
      versions = @fury.versions(@package_name)
      versions.collect { |i| i['version'] }.each do |v|
        if v =~ /^\d+\.\d+\.\d+\-0\.\d+\-.+/
          begin
            @fury.yank_version(@package_name, v)
          rescue Gemfury::NotFound
          end
        end
      end
    end
  end

  shared_examples 'build using modules' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client

      @package_name = 'git.fury.io/furynix/jgo'
      @package_version = '1.0.0'

      @goproxy = 'https://%s@go-proxy.fury.io/%s/' % [ FurynixSpec.furynix_api_token,
                                                       FurynixSpec.furynix_user ]
      @goprivate = 'git.fury.io/furynix/*'
      @gonoproxy = 'none'

      begin
        versions = @fury.versions(@package_name)
        unless versions.detect { |v| v['version'] == @package_version }
          raise 'Required jgo version not in repo'
        end
      end
    end

    it 'should build using GOPROXY' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'out_file' => FurynixSpec.calculate_build_path(@out_file_path),
                                'GOPROXY' => @goproxy,
                                'GOPRIVATE' => @goprivate,
                                'GONOPROXY' => @gonoproxy
                              })

      ret = container.run(:exec => '/build/spec/exec/go_build_hgo',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))

      expect(ret).to be_a_docker_success
    end

    it 'should build using direct Git access' do
      skip "This only works if user is 'furynix'" if FurynixSpec.furynix_user != 'furynix'

      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'out_file' => FurynixSpec.calculate_build_path(@out_file_path),
                                'GOPRIVATE' => @goprivate,
                                'GONOPROXY' => 'git.fury.io/furynix/*'
                              })

      ret = container.run(:exec => '/build/spec/exec/go_build_hgo',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))

      expect(ret).to be_a_docker_success
    end
  end

  describe 'in Go' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.go'
    end

    it_should_behave_like 'build and push'
    it_should_behave_like 'build using modules'
  end
end
