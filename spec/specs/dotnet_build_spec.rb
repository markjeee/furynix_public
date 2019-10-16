require_relative '../spec_helper'

describe 'Dotnet' do
  shared_examples 'build and push' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client
    end

    it 'should build and push' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'package_path' => 'bin/Debug/Gemfury.DotNetWorld.1.1.0.nupkg',
                                'package_name' => 'Gemfury.DotNetWorld',
                                'package_version' => '1.1.0',
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                              })

      ret = container.run(:exec => '/build/spec/exec/dotnet_build_world',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))

      expect(ret).to be_a_docker_success

      # disabled for now, since API call do not support package name with a '.'
      #gem_info = @fury.package_info('Gemfury.DotNetWorld')
      #expect(gem_info['versions'].collect { |i| i['version'] }).to include('1.1.0')
    end

    after do
      begin
        @fury.yank_version('Gemfury.DotNetWorld', '1.1.0')
      rescue Gemfury::NotFound
      end
    end
  end

  shared_examples 'build using pkg' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client

      begin
        @fury.package_info('pkg_1Ealmk')['package']
      rescue Gemfury::NotFound
        f = File.new(FurynixSpec.fixtures_path('Gemfury.DotNetWorld.1.0.0.nupkg'))
        @fury.push_gem(f)
        @fury.update_privacy('pkg_1Ealmk', false)
      end
    end

    it 'should build' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

      ret = container.run(:exec => '/build/spec/exec/dotnet_build_hello',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))

      expect(ret).to be_a_docker_success

      lines = File.read(@out_file_path).split("\n")
      expect(lines[0]).to eq('Hello World')
    end
  end

  describe 'in dotnet' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.dotnet'
    end

    it_should_behave_like 'build and push'
    it_should_behave_like 'build using pkg'
  end
end
