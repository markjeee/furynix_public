require_relative '../spec_helper'

describe 'Curl API' do
  before do
    FurynixSpec.prepare

    @out_file_path = FurynixSpec.prepare_docker_outfile
  end

  it 'should return user info' do
    container = DockerTask.containers['furynix-spec.bionic']
    container.pull

    env = FurynixSpec.
            create_env_args({ 'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

    ret = container.run(:exec => '/build/spec/exec/curl_users_me',
                        :capture => true,
                        :env_file => FurynixSpec.create_env_file(env))

    expect(ret).to be_a_docker_success
  end

  it 'should add and remove a collaborator by username' do
    container = DockerTask.containers['furynix-spec.bionic']
    container.pull

    env = FurynixSpec.
            create_env_args({ 'user1' => 'furynix-user1',
                              'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

    ret = container.run(:exec => '/build/spec/exec/curl_add_remove_collaborator',
                        :capture => true,
                        :env_file => FurynixSpec.create_env_file(env))

    expect(ret).to be_a_docker_success
  end

  it 'should add and remove a collaborator by email' do
    skip 'Disabled for now since adding by email has a bug'
    container = DockerTask.containers['furynix-spec.bionic']
    container.pull

    env = FurynixSpec.
            create_env_args({ 'user1' => 'furynix-user1@nlevel.io',
                              'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

    ret = container.run(:exec => '/build/spec/exec/curl_add_remove_collaborator',
                        :capture => true,
                        :env_file => FurynixSpec.create_env_file(env))

    expect(ret).to be_a_docker_success
  end
end
