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
      install_spec('https://gem.fury.io/cli/', true)
      should_install_fury(true)
    end

    def install_spec(domain, dev_version = nil)
      container = DockerTask.containers[@container_key]

      container.pull
      ret = container.runi(:exec => '"/build/spec/exec/rubygems_install_gemfury %s %s %s %s"' %
                                    [ FurynixSpec.calculate_build_path(@out_file_path),
                                      domain,
                                      dev_version ? '1' : nil,
                                      @rubygem_version
                                    ])
      expect(ret).to be_truthy
    end

    def should_install_fury(dev_version = nil)
      expect(File.exists?(@out_file_path)).to be_truthy

      lines = File.read(@out_file_path).split("\n")
      expect(lines[0]).to eq('/usr/local/bundle/bin/fury')

      unless dev_version.nil?
        expect(lines[1]).to eq(FurynixSpec.current_gemfury_dev_version)
      else
        expect(lines[1]).to eq(FurynixSpec.current_gemfury_version)
      end
    end
  end

  describe 'using ruby 2.6.2' do
    before do
      skip 'for now' if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.ruby262'
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
    end

    it_should_behave_like 'installing CLI fury'
  end

  if FurynixSpec.include_all_ruby
    describe 'using ruby 2.5.3' do
      before do
        skip 'for now' if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.ruby253'
        @dev_version = nil
        @rubygem_version = nil
      end

      it_should_behave_like 'installing CLI fury'
    end

    describe 'using ruby 2.4.5' do
      before do
        skip 'for now' if FurynixSpec.skip_if_only_one
        @container_key = 'furynix-spec.ruby245'
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