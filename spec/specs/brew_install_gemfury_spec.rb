require_relative '../spec_helper'

describe 'Linuxbrew' do
  shared_examples 'install CLI' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
    end

    it 'should install v%s' % FurynixSpec.gemfury_version do
      ret = brew_install_gemfury('gemfury/tap')

      expect(ret).to be_a_docker_success
      expect_fury_version(FurynixSpec.gemfury_version)
    end

    it 'should install dev version v%s' % FurynixSpec.gemfury_brew_dev_version do
      ret = brew_install_gemfury('gemfury/tap', true)

      expect(ret).to be_a_docker_success
      expect_fury_version(FurynixSpec.gemfury_brew_dev_version)
    end

    def brew_install_gemfury(source, devel = nil)
      container = DockerTask.containers[@container_key]
      container.pull

      args = FurynixSpec.
               create_exec_args({ 'source' => source,
                                  'out_file' => FurynixSpec.calculate_build_path(@out_file_path),
                                  'devel' => devel
                                })

      container.run(:exec => '"/build/spec/exec/brew_install_gemfury %s"' %
                             FurynixSpec.pass_exec_args(args),
                    :capture => true)
    end

    def expect_fury_version(version)
      expect(File.exists?(@out_file_path)).to be_truthy

      lines = File.read(@out_file_path).split("\n")
      expect(lines[0]).to eq('/home/linuxbrew/.linuxbrew/bin/fury')
      expect(lines[1]).to eq(version)
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
