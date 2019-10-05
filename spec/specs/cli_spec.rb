require_relative '../spec_helper'

describe 'CLI' do
  shared_examples 'exec CLI' do
    before do
      FurynixSpec.prepare
      @container = nil

      @out_file_path = FurynixSpec.prepare_docker_outfile
      @fury = FurynixSpec.gemfury_client
    end

    it 'should show version, user, and packages' do
      prepare_gemfury_gem
      ret = cli_list_test('https://apt.fury.io/cli/')
      expect(ret).to be_truthy

      expect(File.exists?(@out_file_path)).to be_truthy
      line_groups = parse_out_file

      expect_fury_version(line_groups, FurynixSpec.current_gemfury_dev_version)
      expect_whoami_furynix(line_groups)
      expect_gemfury_listed(line_groups)
    end

    it 'should push a gem' do
      gem = '/build/spec/fixtures/rspec-support-3.8.3.gem'
      yank_if_exist('rspec-support', '3.8.3')

      ret = cli_push_test('https://apt.fury.io/cli/', gem)
      expect(ret).to be_truthy

      line_groups = parse_out_file
      lines = line_groups[2]
      expect(lines[0]).to match(/Uploading #{File.basename(gem)}.+\- done/)
      yank_if_exist('rspec-support', '3.8.3', true)
    end

    it 'should push multiple gems' do
      gems = [ [ 'rspec-support', '3.8.3' ],
               [ 'httparty', '0.17.0' ] ]

      gems.each do |gem|
        yank_if_exist(*gem)
      end

      gem_files = gems.collect { |gem| '/build/spec/fixtures/%s-%s.gem' % gem }
      ret = cli_push_test('https://apt.fury.io/cli/', gem_files.join(' '))
      expect(ret).to be_truthy

      line_groups = parse_out_file
      lines = line_groups[2]

      i = 0
      gem_files.each do |gemf|
        expect(lines[i]).to match(/Uploading #{File.basename(gemf)}.+\- done/)
        yank_if_exist(gems[i][0], gems[i][1], true)
        i += 1
      end
    end

    private

    def prepare_gemfury_gem
      begin
        @fury.package_info('gemfury')['package']
      rescue Gemfury::NotFound
        f = File.new(FurynixSpec.fixtures_gemfury_gem)
        @fury.push_gem(f)
        @fury.update_privacy('gemfury', false)
      end
    end

    def yank_if_exist(gem, version, nosleep = false)
      begin
        ret = @fury.yank_version(gem, version)

        # sleep is enforced here to allow backend to complete async tasks
        sleep(5) unless nosleep
      rescue Gemfury::NotFound
        # ignore
      end

      ret
    end

    def expect_fury_version(line_groups, version)
      lines = line_groups[0]
      expect(lines[0]).to eq('/usr/local/bin/fury')

      lines = line_groups[1]
      expect(lines[0]).to eq(version)
    end

    def expect_whoami_furynix(line_groups)
      lines = line_groups[2]

      expect(lines[0]).to eq('You are logged in as "%s"' % FurynixSpec.furynix_user)
    end

    def expect_gemfury_listed(line_groups)
      lines = line_groups[3]

      gemfury_count = lines.select { |l| l =~ /^gemfury\s.+/ }.count
      expect(gemfury_count).to be > 0
    end

    def parse_out_file
      lines = File.read(@out_file_path).split("\n")

      groups = [ ]
      this_group = [ ]
      lines.each do |l|
        if l == '=~=~=~='
          groups << this_group
          this_group = [ ]
        else
          this_group << l
        end
      end

      unless this_group.empty?
        groups << this_group
        this_group = [ ]
      end

      groups
    end

    def container
      if defined?(@container) && !@container.nil?
        @container
      else
        @container = DockerTask.containers[@container_key]
        @container.pull
        @container
      end
    end

    def cli_list_test(source)
      args = FurynixSpec.
               create_exec_args({ 'source' => source,
                                  'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                                })

      container.runi(:exec => '"/build/spec/exec/cli_list_test %s"' %
                              FurynixSpec.pass_exec_args(args))
    end

    def cli_push_test(source, gem)
      args = FurynixSpec.
               create_exec_args({ 'source' => source,
                                  'gem' => '"%s"' % gem,
                                  'out_file' => FurynixSpec.calculate_build_path(@out_file_path)
                                })

      container.runi(:exec => '"/build/spec/exec/cli_push_test %s"' %
                              FurynixSpec.pass_exec_args(args))
    end
  end

  describe 'in ubuntu/bionic' do
    before do
      skip if FurynixSpec.skip_if_only_one
      @container_key = 'furynix-spec.bionic'
    end

    it_should_behave_like 'exec CLI'
  end
end
