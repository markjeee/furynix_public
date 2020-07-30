require_relative '../spec_helper'

describe 'Curl API' do
  before do
    FurynixSpec.prepare

    @out_file_path = FurynixSpec.prepare_docker_outfile
  end

  it 'should return list of repos' do
    container = DockerTask.containers['furynix-spec.bionic']
    container.pull

    env = FurynixSpec.
            create_env_args({ 'username' => 'furynix',
                              'repo' => 'gem_for_repo',
                              'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

    ret = container.run(:exec => '/build/spec/exec/curl_repos',
                        :capture => true,
                        :env_file => FurynixSpec.create_env_file(env))

    expect(ret).to be_a_docker_success
  end

  it 'should set git config vars' do
    container = DockerTask.containers['furynix-spec.bionic']
    container.pull

    env = FurynixSpec.
            create_env_args({ 'username' => 'furynix',
                              'repo' => 'gem_for_repo',
                              'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

    ret = container.run(:exec => '/build/spec/exec/curl_repos_config_vars',
                        :capture => true,
                        :env_file => FurynixSpec.create_env_file(env))

    expect(ret).to be_a_docker_success
  end
end
