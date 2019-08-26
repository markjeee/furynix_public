module FurynixSpec
  def self.define_docker_containers
    DockerTask.load_containers
  end
end

FurynixSpec.define_docker_containers
