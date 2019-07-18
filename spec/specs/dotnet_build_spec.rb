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
      ret = container.runi(:exec => '"/build/spec/exec/dotnet_build_world %s"' %
                                    [ FurynixSpec.calculate_build_path(@out_file_path) ])

      expect(ret).to be_truthy
      expect(File.exists?(@out_file_path)).to be_truthy

      #lines = File.read(@out_file_path).split("\n")
      #expect(lines[0]).to eq('/home/linuxbrew/.linuxbrew/bin/fury')
      #expect(lines[1]).to eq(FurynixSpec.current_gemfury_version)
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
