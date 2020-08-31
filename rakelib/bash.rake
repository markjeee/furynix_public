namespace :bash do
  desc 'Bash to ruby26 environment'
  task :ruby27 do
    c = DockerTask.containers['furynix.ruby27']
    c.pull
    c.runi
  end

  desc 'Bash to ruby26 environment'
  task :ruby26 do
    c = DockerTask.containers['furynix.ruby26']
    c.pull
    c.runi
  end

  desc 'Bash to ruby19 environment'
  task :ruby19 do
    c = DockerTask.containers['furynix.ruby19']
    c.pull
    c.runi
  end

  desc 'Bash to bionic environment'
  task :bionic do
    c = DockerTask.containers['furynix.bionic']
    c.pull
    c.runi
  end

  desc 'Bash to CentOS 7 environment'
  task :centos7 do
    c = DockerTask.containers['furynix.centos7']
    c.pull
    c.runi
  end

  desc 'Bash to Linuxbrew environment'
  task :linuxbrew do
    c = DockerTask.containers['furynix.linuxbrew']
    c.pull
    c.runi
  end

  desc 'Bash to buster environment'
  task :buster do
    c = DockerTask.containers['furynix.buster']
    c.pull
    c.runi
  end

  desc 'Bash to stretch environment'
  task :stretch do
    c = DockerTask.containers['furynix.stretch']
    c.pull
    c.runi
  end

  desc 'Bash to Dotnet environment'
  task :dotnet do
    c = DockerTask.containers['furynix.dotnet']
    c.pull
    c.runi
  end

  desc 'Bash to Gradle environment'
  task :gradle do
    c = DockerTask.containers['furynix.gradle']
    c.pull
    c.runi
  end

  desc 'Bash to Go environment'
  task :go do
    c = DockerTask.containers['furynix.go']
    c.pull
    c.runi
  end
end

namespace :vagrant do
  desc 'Rake on GCP instance'
  task :gcp_rake do
    sh "vagrant ssh -c \"cd /furynix; rake\" gcp"
  end

  desc 'Rake on GCP instance (parallel: 3)'
  task :gcp_rake3 do
    sh "vagrant ssh -c \"cd /furynix; rake parallel:spec[3]\" gcp"
  end

  desc 'Rake on AWS instance'
  task :aws_rake do
    sh "vagrant ssh -c \"cd /furynix; rake\" aws"
  end

  desc 'Rake on AWS instance (parallel: 3)'
  task :aws_rake3 do
    sh "vagrant ssh -c \"cd /furynix; rake parallel:spec[3]\" aws"
  end

  desc 'Rake on mark-qnuc instance'
  task :qnuc_rake do
    sh "vagrant ssh -c \"cd /opt/furynix; rake\" mark-qnuc"
  end

  desc 'Rake on AWS instance (parallel: 3)'
  task :qnuc_rake3 do
    sh "vagrant ssh -c \"cd /opt/furynix; rake parallel:spec[3]\" mark-qnuc"
  end
end
