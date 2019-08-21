require_relative '../spec_helper'

describe 'RubyGems' do
  shared_examples 'app using gem' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
    end

    it 'should bundle and test' do
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
