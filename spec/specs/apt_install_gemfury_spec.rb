require_relative '../spec_helper'
require 'uri'

describe 'APT' do
  shared_examples 'install CLI' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
    end

    it 'should install v%s' % FurynixSpec.gemfury_version do
      skip if FurynixSpec.skip_if_only_one

      ret = apt_install_gemfury('https://apt.fury.io/cli/',
                                FurynixSpec.gemfury_version)

      expect(ret).to be_a_docker_success
      expect_fury_version(FurynixSpec.gemfury_version)
    end

    it 'should install using custom domain' do
      skip if FurynixSpec.skip_if_only_one

      ret = apt_install_gemfury('https://cli.gemfury.com/apt/',
                                FurynixSpec.gemfury_version)

      expect(ret).to be_a_docker_success
      expect_fury_version(FurynixSpec.gemfury_version)
    end

    it 'should install dev version v%s' % FurynixSpec.gemfury_dev_version do
      skip if FurynixSpec.skip_if_only_one

      ret = apt_install_gemfury('https://apt.fury.io/cli-dev/',
                                FurynixSpec.gemfury_dev_version)

      expect(ret).to be_a_docker_success
      expect_fury_version(FurynixSpec.gemfury_dev_version)
    end

    FurynixSpec.gemfury_head_versions.each do |v|
      it 'should install v%s' % v do
        skip if FurynixSpec.skip_if_only_one

        ret = apt_install_gemfury('https://apt.fury.io/cli-dev/', v)

        expect(ret).to be_a_docker_success
        expect_fury_version(v)
      end
    end

    it 'should install private package' do
      ret = apt_install_gemfury('https://apt.fury.io/%s/' % FurynixSpec.furynix_user,
                                FurynixSpec.gemfury_version)
      expect(ret).to be_a_docker_success

      expect_fury_version(FurynixSpec.gemfury_version)
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

      u = URI.parse(source)
      source_host = u.host

      env = FurynixSpec.
              create_env_args({ 'source' => source,
                                'source_host' => source_host,
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path),
                                'version' => version
                              })

      container.run(:exec => '/build/spec/exec/apt_install_gemfury',
                    :capture => true,
                    :env_file => FurynixSpec.create_env_file(env))
    end
  end

  describe 'in ubuntu/focal' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.focal'
    end

    it_should_behave_like 'install CLI'
  end

  describe 'in ubuntu/bionic' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.bionic'
    end

    it_should_behave_like 'install CLI'
  end

  describe 'in debian/buster' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.buster'
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
