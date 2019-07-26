require_relative '../spec_helper'

describe 'Dotnet' do
  shared_examples 'build and push' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
    end

    it 'should build and push' do
      skip 'Since Nuget repo at furynix has a bug'
      container = DockerTask.containers[@container_key]

      api_token = ENV['FURYNIX_API_TOKEN']
      expect(api_token).to_not be_empty

      container.pull
      ret = container.runi(:exec => '"/build/spec/exec/dotnet_build_world %s %s %s %s %s"' %
                                    [ FurynixSpec.calculate_build_path(@out_file_path),
                                      api_token,
                                      'bin/Debug/Gemfury.DotNetWorld.1.0.0.nupkg',
                                      'Gemfury.DotNetWorld',
                                      '1.0.0',
                                    ])

      expect(ret).to be_truthy
    end

    it 'should build' do
      skip 'Since Nuget repo at furynix has a bug'
      container = DockerTask.containers[@container_key]

      api_token = ENV['FURYNIX_API_TOKEN']
      expect(api_token).to_not be_empty

      container.pull
      ret = container.runi(:exec => '"/build/spec/exec/dotnet_build_hello %s %s"' %
                                    [ FurynixSpec.calculate_build_path(@out_file_path),
                                      api_token
                                    ])

      expect(ret).to be_truthy
    end
  end

  describe 'in dotnet' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.dotnet'
    end

    it_should_behave_like 'build and push'
  end
end
