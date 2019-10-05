require_relative '../spec_helper'

describe 'RubyGems' do
  shared_examples 'app using gem' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client
    end

    it 'should bundle and test' do
      prepare_needed_gem
      container = DockerTask.containers[@container_key]

      container.pull

      args = FurynixSpec.
               create_exec_args({ 'source_url' => FurynixSpec.furynix_source_url('gem'),
                                  'gemfile' => @gemfile,
                                  'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                                })

      ret = container.runi(:exec => '"/build/spec/exec/app_using_gem_test %s"' %
                                    FurynixSpec.pass_exec_args(args))

      expect(ret).to be_truthy
    end

    def prepare_needed_gem
      begin
        @fury.package_info('gem_using_bundler')['package']
      rescue Gemfury::NotFound
        f = File.new(File.join(FurynixSpec.fixtures_path, 'gem_using_bundler-0.1.0.gem'))
        @fury.push_gem(f)
        @fury.update_privacy('gem_using_bundler', false)
      end
    end
  end

  describe 'using ruby 2.6.3' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.ruby263'
      @gemfile = nil
    end

    it_should_behave_like 'app using gem'
  end

  describe 'using ruby 1.9.3' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.ruby193'
      @gemfile = '/build/app_using_gem/gemfiles/Gemfile19'
    end

    it_should_behave_like 'app using gem'
  end

  if FurynixSpec.include_all_ruby
    describe 'using ruby 2.5.5' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.ruby255'
        @gemfile = nil
      end

      it_should_behave_like 'app using gem'
    end

    describe 'using ruby 2.4.6' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.ruby246'
        @gemfile = nil
      end

      it_should_behave_like 'app using gem'
    end

    describe 'using ruby 2.3.8' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.ruby238'
        @gemfile = nil
      end

      it_should_behave_like 'app using gem'
    end
  end
end
