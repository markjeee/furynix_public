require_relative '../spec_helper'

describe 'Linuxbrew' do
  shared_examples 'install CLI' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
    end

    it 'should install' do
      container = DockerTask.containers[@container_key]

      container.pull
      ret = container.runi(:exec => '"/build/spec/exec/brew_install_gemfury %s %s"' %
                                    [ FurynixSpec.calculate_build_path(@out_file_path),
                                      'gemfury/tap' ])

      expect(ret).to be_truthy
      expect(File.exists?(@out_file_path)).to be_truthy

      lines = File.read(@out_file_path).split("\n")
      expect(lines[0]).to eq('/home/linuxbrew/.linuxbrew/bin/fury')
      expect(lines[1]).to eq(FurynixSpec.current_gemfury_version)
    end
  end

  describe 'in linuxbrew' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.linuxbrew'
    end

    it_should_behave_like 'install CLI'
  end
end
