require_relative '../spec_helper'

describe 'APT' do
  shared_examples 'install CLI' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
    end

    it 'should install' do
      ret = apt_install_gemfury('https://apt.fury.io/cli/',
                                FurynixSpec.current_gemfury_version)

      expect(ret).to be_truthy
      expect_fury_version(FurynixSpec.current_gemfury_version)
    end

    it 'should install dev version' do
      ret = apt_install_gemfury('https://apt.fury.io/cli/',
                                FurynixSpec.current_gemfury_dev_version)

      expect(ret).to be_truthy
      expect_fury_version(FurynixSpec.current_gemfury_dev_version)
    end

    it 'should install using custom domain' do
      ret = apt_install_gemfury('https://cli.gemfury.com/apt/',
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

    def apt_install_gemfury(source, version = nil)
      container = DockerTask.containers[@container_key]
      container.pull

      args = FurynixSpec.
               create_exec_args({ 'source' => source,
                                  'out_file' => FurynixSpec.calculate_build_path(@out_file_path),
                                  'version' => version
                                })

      container.runi(:exec => '"/build/spec/exec/apt_install_gemfury %s"' %
                              FurynixSpec.pass_exec_args(args))
    end
  end

  describe 'in ubuntu/bionic' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.bionic'
    end

    it_should_behave_like 'install CLI'
  end

  describe 'in debian/stretch' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.stretch'
    end

    it_should_behave_like 'install CLI'
  end

  if FurynixSpec.include_all_systems
    describe 'in ubuntu/xenial' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.xenial'
      end

      it_should_behave_like 'install CLI'
    end

    describe 'in ubuntu/trusty' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.trusty'
      end

      it_should_behave_like 'install CLI'
    end

    describe 'in debian/jessie' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.jessie'
      end

      it_should_behave_like 'install CLI'
    end

    describe 'in debian/wheezy' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.wheezy'
      end

      it_should_behave_like 'install CLI'
    end
  end
end
