require_relative '../spec_helper'

describe 'Maven' do
  shared_examples 'compile and deploy' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client

      @package_name = 'org.furynix/jworld'
      @package_version = '1.1'
      @snapshot_version = /^1\.1\-\d{8}\.\d{6}\-\d$/
      @actual_snapshot_version = nil
    end

    it 'should compile and deploy' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'package_path' => 'target/jworld-1.1*.jar',
                                'package_name' => @package_name,
                                'package_version' => @package_version,
                                'FURYNIX_PUSH_ENDPOINT' => @push_endpoint,
                                'POM_FILE' => 'pom.xml',
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                              })

      ret = container.run(:exec => '/build/spec/exec/maven_build_jworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))
      expect(ret).to be_a_docker_success

      versions = @fury.versions(@package_name)
      expect(versions.collect { |i| i['version'] }).to include(@package_version)
    end

    it 'should compile and deploy (snapshot)' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'package_path' => 'target/jworld-1.1*.jar',
                                'package_name' => @package_name,
                                'package_version' => @package_version,
                                'FURYNIX_PUSH_ENDPOINT' => @push_endpoint,
                                'POM_FILE' => 'pom.snapshot.xml',
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                              })

      ret = container.run(:exec => '/build/spec/exec/maven_build_jworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))
      expect(ret).to be_a_docker_success

      versions = @fury.versions(@package_name)
      expect(versions.collect { |i| i['version'] }).to include(match @snapshot_version)

      @actual_snapshot_version = (versions.collect { |i| i['version'] }).select { |v| v =~ @snapshot_version }.first
    end

    after do
      unless @fury.nil?
        begin
          @fury.yank_version(@package_name, @package_version)
          sleep(10)
        rescue Gemfury::NotFound
        end

        unless @actual_snapshot_version.nil?
          begin
            @fury.yank_version(@package_name, @actual_snapshot_version)
            sleep(10)
          rescue Gemfury::NotFound
          end
        end
      end
    end
  end

  shared_examples 'multi-project compile and deploy' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client

      @packages = [ { name: 'org.furynix/nworld',
                      version: '1.1' },
                    { name: 'org.furynix.nworld/jhello',
                      version: '1.1' },
                    { name: 'org.furynix.nworld/jworld',
                      version: '1.1' } ]
    end

    it 'should compile and deploy' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'FURYNIX_PUSH_ENDPOINT' => @push_endpoint,
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                              })

      ret = container.run(:exec => '/build/spec/exec/maven_build_nworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))
      expect(ret).to be_a_docker_success

      @packages.each do |p_info|
        versions = @fury.versions(p_info[:name])
        expect(versions.collect { |i| i['version'] }).to include(p_info[:version])
      end
    end

    after do
      unless @fury.nil?
        begin
          @packages.each do |p_info|
            @fury.yank_version(p_info[:name], p_info[:version])
          end

          sleep(10)
        rescue Gemfury::NotFound
        end
      end
    end
  end

  shared_examples 'build using pkg' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client

      begin
        @fury.versions('org.furynix/jworld')
      rescue Gemfury::NotFound
        f = File.new(FurynixSpec.fixtures_path('jworld-1.0.jar'))
        @fury.push_gem(f)
      end
    end

    it 'should build' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'out_file' => FurynixSpec.calculate_build_path(@out_file_path),
                                'POM_FILE' => 'pom.xml'
                              })

      ret = container.run(:exec => '/build/spec/exec/maven_build_hworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))

      expect(ret).to be_a_docker_success
    end

    it 'should build (multi-project)' do
      skip 'At the moment multi-project modules return 404'

      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'out_file' => FurynixSpec.calculate_build_path(@out_file_path),
                                'POM_FILE' => 'pom.multi.xml'
                              })

      ret = container.run(:exec => '/build/spec/exec/maven_build_hworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))

      expect(ret).to be_a_docker_success
    end
  end

  describe 'in maven' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.maven'
      @push_endpoint = 'maven.fury.io'
    end

    it_should_behave_like 'build using pkg'
  end

  describe 'in maven (endpoint: maven.fury.io)' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.maven'
      @push_endpoint = 'maven.fury.io'
    end

    it_should_behave_like 'compile and deploy'
    it_should_behave_like 'multi-project compile and deploy'
  end

  describe 'in maven (endpoint: push.fury.io)' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.maven'
      @push_endpoint = 'push.fury.io'
    end

    it_should_behave_like 'compile and deploy'
    it_should_behave_like 'multi-project compile and deploy'
  end
end
