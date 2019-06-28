require_relative '../spec_helper'

describe 'Node' do
  shared_examples 'module using npm' do
    before do
      FurynixSpec.prepare

      @out_file_path = FurynixSpec.prepare_docker_outfile
    end

    it 'should build and release' do
      container = DockerTask.containers[@container_key]

      api_token = ENV['FURYNIX_API_TOKEN']
      expect(api_token).to_not be_empty

      container.pull
      ret = container.runi(:exec => '"/build/spec/exec/module_using_npm_test %s %s"' %
                                    [ FurynixSpec.calculate_build_path(@out_file_path),
                                      api_token
                                    ])

      expect(ret).to be_truthy
    end
  end

  describe 'using node 11.9' do
    before do
      @container_key = 'furynix-spec.node119'
    end

    it_should_behave_like 'module using npm'
  end
end
