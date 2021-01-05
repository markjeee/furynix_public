require_relative '../spec_helper'

describe 'Gradle' do
  shared_examples 'build and push' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client

      @package_name = 'org.furynix/jworld'
      @package_version = '1.1'
      @snapshot_version = /^1\.2\-\d{8}\.\d{6}.*$/
      @actual_snapshot_version = nil
    end

    it 'should build and push' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'package_path' => 'build/libs/jworld-1.1*.jar',
                                'package_name' => @package_name,
                                'package_version' => @package_version,
                                'FURYNIX_PUSH_ENDPOINT' => @push_endpoint,
                                'BUILD_FILE' => 'build.gradle',
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                              })

      ret = nil
      ret = container.run(:exec => '/build/spec/exec/gradle_build_jworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))
      expect(ret).to be_a_docker_success

      versions = @fury.versions(@package_name)
      expect(versions.collect { |i| i['version'] }).to include(@package_version)
    end

    it 'should build and push (snapshot)' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'package_path' => 'build/libs/jworld-1.2*.jar',
                                'package_name' => @package_name,
                                'package_version' => @package_version,
                                'FURYNIX_PUSH_ENDPOINT' => @push_endpoint,
                                'BUILD_FILE' => 'build.snapshot.gradle',
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                              })

      ret = nil
      ret = container.run(:exec => '/build/spec/exec/gradle_build_jworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))
      expect(ret).to be_a_docker_success

      versions = @fury.versions(@package_name)
      expect(versions.collect { |i| i['version'] }).to include(match @snapshot_version)

      @actual_snapshot_version = (versions.collect { |i| i['version'] }).select { |v| v =~ @snapshot_version }.first
    end

    after do
      begin
        if defined?(@fury) && !@fury.nil?
          @fury.yank_version(@package_name, @package_version)
          sleep(10)
        end
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

      ret = container.run(:exec => '/build/spec/exec/gradle_build_nworld',
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
        @packages.each do |p_info|
          begin
            @fury.yank_version(p_info[:name], p_info[:version])
          rescue Gemfury::NotFound
          end
        end

        sleep(10)
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
              create_env_args({ 'BUILD_FILE' => 'build.gradle',
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

      ret = nil
      ret = container.run(:exec => '/build/spec/exec/gradle_build_hworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))
      expect(ret).to be_a_docker_success
    end

    it 'should build (multi-project)' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'BUILD_FILE' => 'build.multi.gradle',
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

      ret = nil
      ret = container.run(:exec => '/build/spec/exec/gradle_build_hworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))
      expect(ret).to be_a_docker_success
    end

    it 'should build (snapshot)' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'BUILD_FILE' => 'build.snapshot.gradle',
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

      ret = nil
      ret = container.run(:exec => '/build/spec/exec/gradle_build_hworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))
      expect(ret).to be_a_docker_success
    end
  end

  describe 'in gradle' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.gradle65'
      @push_endpoint = 'maven.fury.io'
    end

    it_should_behave_like 'build using pkg'
  end

  describe 'in gradle (endpoint: maven.fury.io)' do
    before do
      skip "For now, since primary Maven endpoint takes some time to respond, that Gradle don't like"

      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.gradle65'
      @push_endpoint = 'maven.fury.io'
    end

    it_should_behave_like 'build and push'
    it_should_behave_like 'multi-project compile and deploy'
  end

  describe 'in gradle (endpoint: push.fury.io)' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.gradle65'
      @push_endpoint = 'push.fury.io'
    end

    it_should_behave_like 'build and push'
    it_should_behave_like 'multi-project compile and deploy'
  end

  describe 'in gradle (endpoint: maven-beta.fury.io)' do
    before do
      #skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.gradle65'
      @push_endpoint = 'maven-beta.fury.io'
    end

    it_should_behave_like 'build and push'
    it_should_behave_like 'multi-project compile and deploy'
  end
end
