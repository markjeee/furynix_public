module DockerTask
  module Do
    def self.pull(exec_p)
      de = DockerExec.new(exec_p)
      de.pull
    end
  end
end
