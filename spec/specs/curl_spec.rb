require_relative '../spec_helper'

describe 'Curl API' do
  before do
    FurynixSpec.prepare

    @out_file_path = FurynixSpec.prepare_docker_outfile
  end

  it 'should return user info' do
    container = DockerTask.containers['furynix-spec.bionic']

    container.pull
    args = FurynixSpec.
             create_exec_args({ 'out_file' => FurynixSpec.calculate_build_path(@out_file_path) })

    ret = container.runi(:exec => '"/build/spec/exec/curl_users_me %s"' %
                                  FurynixSpec.pass_exec_args(args))

    expect(ret).to be_truthy
  end
end
