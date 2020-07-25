require_relative '../spec_helper'

describe 'RubyGems' do
  shared_examples 'gem using bundler' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client
    end

    it 'should build and release' do
      container = DockerTask.containers[@container_key]
      container.pull

      args = FurynixSpec.
               create_exec_args({ 'push_url' => FurynixSpec.furynix_push_url,
                                  'gemfile' => @gemfile,
                                  'out_file' => FurynixSpec.calculate_build_path(@out_file_path),
                                  'build_version' => '0.1.1'
                                })

      ret = container.run(:exec => '"/build/spec/exec/gem_using_bundler_test %s"' %
                                   FurynixSpec.pass_exec_args(args),
                          :capture => true)

      expect(ret).to be_a_docker_success

      gem_info = @fury.package_info('gem_using_bundler')
      expect(gem_info['versions'].collect { |i| i['version'] }).to include('0.1.1')
    end

    after do
      begin
        unless @fury.nil?
          @fury.yank_version('gem_using_bundler', '0.1.1')
        end
      rescue Gemfury::NotFound
      end
    end
  end

  shared_examples 'app using gem' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client

      begin
        @fury.package_info('gem_using_bundler')['package']
      rescue Gemfury::NotFound
        f = File.new(FurynixSpec.fixtures_path('gem_using_bundler-0.1.0.gem'))
        @fury.push_gem(f)
        @fury.update_privacy('gem_using_bundler', false)
      end
    end

    it 'should bundle and test' do
      container = DockerTask.containers[@container_key]
      container.pull

      args = FurynixSpec.
               create_exec_args({ 'source_url' => FurynixSpec.furynix_source_url('gem'),
                                  'gemfile' => @gemfile,
                                  'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                                })

      ret = container.run(:exec => '"/build/spec/exec/app_using_gem_test %s"' %
                                   FurynixSpec.pass_exec_args(args),
                          :capture => true)

      expect(ret).to be_a_docker_success
    end
  end

  describe 'using ruby 2.7' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.ruby27'
      @gemfile = nil
    end

    it_should_behave_like 'gem using bundler'
    it_should_behave_like 'app using gem'
  end

  describe 'using ruby 2.6' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.ruby26'
      @gemfile = nil
    end

    it_should_behave_like 'gem using bundler'
    it_should_behave_like 'app using gem'
  end

  describe 'using ruby 1.9' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.ruby19'
      @gemfile = '/build/gem_using_bundler/gemfiles/Gemfile19'
    end

    it_should_behave_like 'gem using bundler'
    it_should_behave_like 'app using gem'
  end

  if FurynixSpec.include_all_ruby
    describe 'using ruby 2.5.5' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.ruby255'
        @gemfile = nil
      end

      it_should_behave_like 'gem using bundler'
    end

    describe 'using ruby 2.4.6' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.ruby246'
        @gemfile = nil
      end

      it_should_behave_like 'gem using bundler'
    end

    describe 'using ruby 2.3.8' do
      before do
        skip if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.ruby238'
        @gemfile = nil
      end

      it_should_behave_like 'gem using bundler'
    end
  end
end
