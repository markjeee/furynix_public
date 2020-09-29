require_relative '../spec_helper'

describe 'Node' do
  shared_examples 'module using npm' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client


      @package_name = '@fury/module_using_npm'
      @package_version = '1.0.1'
    end

    it 'should build and release' do
      container = DockerTask.containers[@container_key]
      container.pull

      env = FurynixSpec.
              create_env_args({ 'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                              })

      ret = container.run(:exec => '/build/spec/exec/module_using_npm_test',
                          :capture => true,
                          :env_file => FurynixSpec.create_env_file(env))

      expect(ret).to be_a_docker_success

      versions = @fury.versions(@package_name)
      expect(versions.collect { |i| i['version'] }).to include(@package_version)
    end

    after do
      unless @fury.nil?
        begin
          @fury.yank_version(@package_name, @package_version)
          sleep(10)
        rescue Gemfury::NotFound
        end
      end
    end
  end

  describe 'using node v14' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.node14'
    end

    it_should_behave_like 'module using npm'
  end

  describe 'using node v10' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.node10'
    end

    it_should_behave_like 'module using npm'
  end
end
