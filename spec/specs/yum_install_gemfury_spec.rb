require_relative '../spec_helper'

describe 'YUM' do
  shared_examples 'install CLI' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
    end

    it 'should install' do
      ret = yum_install_gemfury('https://yum.fury.io/cli/',
                                FurynixSpec.current_gemfury_version)
      expect(ret).to be_truthy

      expect_fury_version(FurynixSpec.current_gemfury_version)
    end

    it 'should install dev version' do
      ret = yum_install_gemfury('https://yum.fury.io/cli-dev/',
                                FurynixSpec.current_gemfury_dev_version)
      expect(ret).to be_truthy

      expect_fury_version(FurynixSpec.current_gemfury_dev_version)
    end

    it 'should install using custom domain' do
      ret = yum_install_gemfury('https://cli.gemfury.com/yum/',
                                FurynixSpec.current_gemfury_version)
      expect(ret).to be_truthy

      expect_fury_version(FurynixSpec.current_gemfury_version)
    end

    def expect_fury_version(version)
      expect(File.exists?(@out_file_path)).to be_truthy
      lines = File.read(@out_file_path).split("\n")

      expect(lines[0]).to eq('/usr/local/bin/fury')
      expect(lines[1]).to eq(version)
    end

    def yum_install_gemfury(source, version = nil)
      container = DockerTask.containers[@container_key]
      container.pull

      args = FurynixSpec.
               create_exec_args({ 'source' => source,
                                  'out_file' => FurynixSpec.calculate_build_path(@out_file_path),
                                  'version' => version
                                })

      container.runi(:exec => '"/build/spec/exec/yum_install_gemfury %s"' %
                              FurynixSpec.pass_exec_args(args))
    end
  end

  describe 'in centos/7' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.centos7'
    end

    it_should_behave_like 'install CLI'
  end

  describe 'in fedora/29' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.fedora29'
    end

    it_should_behave_like 'install CLI'
  end

  if FurynixSpec.include_all_systems
    describe 'in fedora/27' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.fedora27'
      end

      it_should_behave_like 'install CLI'
    end

    describe 'in fedora/23' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.fedora23'
      end

      it_should_behave_like 'install CLI'
    end
  end
end
