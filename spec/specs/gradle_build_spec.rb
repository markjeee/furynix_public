require_relative '../spec_helper'

describe 'Gradle' do
  shared_examples 'build and push' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client
    end

    it 'should build and push' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'package_path' => 'build/repo/org/furynix/jworld/1.1/jworld-1.1.jar',
                                'package_name' => 'org.furynix/jworld',
                                'package_version' => '1.1',
                                'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                              })

      ret = container.run(:exec => '/build/spec/exec/gradle_build_jworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))

      expect(ret).to be_a_docker_success

      versions = @fury.versions('org.furynix/jworld')
      expect(versions.collect { |i| i['version'] }).to include('1.1')
    end

    after do
      begin
        @fury.yank_version('org.furynix/jworld', '1.1')
      rescue Gemfury::NotFound
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
              create_env_args({ 'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

      ret = container.run(:exec => '/build/spec/exec/gradle_build_hworld',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))

      expect(ret).to be_a_docker_success
    end
  end

  describe 'in gradle' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.gradle'
    end

    it_should_behave_like 'build and push'
    it_should_behave_like 'build using pkg'
  end
end
