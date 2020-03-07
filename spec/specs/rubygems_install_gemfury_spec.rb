require_relative '../spec_helper'

describe 'RubyGems' do
  shared_examples 'installing CLI fury' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
    end

    it 'should install' do
      install_spec('https://gem.fury.io/cli/')
      should_install_fury
    end

    it 'should install using custom domain' do
      install_spec('https://cli.gemfury.com/ruby/')
      should_install_fury
    end

    it 'should install using dev version' do
      install_spec('https://gem.fury.io/cli-dev/', FurynixSpec.gemfury_dev_version)
      should_install_fury(FurynixSpec.gemfury_dev_version)
    end

    it 'should install using head version' do
      install_spec('https://gem.fury.io/cli-dev/', FurynixSpec.gemfury_head_version)
      should_install_fury(FurynixSpec.gemfury_head_version)
    end

    def install_spec(source, dev_version = nil)
      container = DockerTask.containers[@container_key]

      container.pull
      args = FurynixSpec.
               create_exec_args({ 'source' => source,
                                  'dev_version' => dev_version,
                                  'rubygem_version' => @rubygem_version,
                                  'thor_version' => @thor_version,
                                  'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                                })

      ret = container.run(:exec => '"/build/spec/exec/rubygems_install_gemfury %s"' %
                                   FurynixSpec.pass_exec_args(args),
                          :capture => true)

      expect(ret).to be_a_docker_success
    end

    def should_install_fury(v = nil)
      expect(File.exists?(@out_file_path)).to be_truthy

      lines = File.read(@out_file_path).split("\n")
      expect(lines[0]).to eq('/usr/local/bundle/bin/fury')

      unless v.nil?
        expect(lines[1]).to eq(v)
      else
        expect(lines[1]).to eq(FurynixSpec.gemfury_version)
      end
    end
  end

  describe 'using ruby 2.6.3' do
    before do
      skip 'for now' if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.ruby263'
      @rubygem_version = nil
    end

    it_should_behave_like 'installing CLI fury'
  end

  describe 'using ruby 1.9.3' do
    before do
      skip 'for now' if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.ruby193'
      @dev_version = nil
      @rubygem_version = nil
      @thor_version = '0.20.3'
    end

    it_should_behave_like 'installing CLI fury'
  end

  if FurynixSpec.include_all_ruby
    describe 'using ruby 2.5.5' do
      before do
        skip 'for now' if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.ruby255'
        @dev_version = nil
        @rubygem_version = nil
      end

      it_should_behave_like 'installing CLI fury'
    end

    describe 'using ruby 2.4.6' do
      before do
        skip 'for now' if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.ruby246'
        @dev_version = nil
        @rubygem_version = nil
      end

      it_should_behave_like 'installing CLI fury'
    end

    describe 'using ruby 2.3.8' do
      before do
        skip 'for now' if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.ruby238'
        @dev_version = nil
        @rubygem_version = nil
      end

      it_should_behave_like 'installing CLI fury'
    end
  end
end
