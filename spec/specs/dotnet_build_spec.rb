require_relative '../spec_helper'

describe 'Dotnet' do
  shared_examples 'build and push' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
    end

    it 'should build and push' do
      container = DockerTask.containers[@container_key]

      container.pull
      args = FurynixSpec.
               create_exec_args({ 'package_path' => 'bin/Debug/Gemfury.DotNetWorld.1.0.0.nupkg',
                                  'package_name' => 'Gemfury.DotNetWorld',
                                  'package_version' => '1.0.0',
                                  'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                                })

      ret = container.runi(:exec => '"/build/spec/exec/dotnet_build_world %s"' %
                                    FurynixSpec.pass_exec_args(args))


      expect(ret).to be_truthy
    end

    it 'should build' do
      container = DockerTask.containers[@container_key]

      api_token = ENV['FURYNIX_API_TOKEN']
      expect(api_token).to_not be_empty

      container.pull
      args = FurynixSpec.
               create_exec_args({ 'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

      ret = container.runi(:exec => '"/build/spec/exec/dotnet_build_hello %s"' %
                                    FurynixSpec.pass_exec_args(args))

      expect(ret).to be_truthy

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
  end
end
