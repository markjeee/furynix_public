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
      ret = cli_list_test('https://apt.fury.io/cli/')
      expect(ret).to be_truthy

      expect(File.exists?(@out_file_path)).to be_truthy
      line_groups = parse_out_file

      expect_fury_version(line_groups, FurynixSpec.current_gemfury_version)
      expect_whoami_furynix(line_groups)
      expect_gemfury_listed(line_groups)
    end

    it 'should push a gem' do
      gem = '/build/spec/fixtures/rspec-core-3.8.1.gem'
      yank_if_exist('rspec-core', '3.8.1')

      ret = cli_push_test('https://apt.fury.io/cli/', gem)
      expect(ret).to be_truthy

      line_groups = parse_out_file
      lines = line_groups[2]
      expect(lines[0]).to match(/Uploading #{File.basename(gem)}.+\- done/)
    end

    it 'should push multiple gems' do
      gems = [ '/build/spec/fixtures/rspec-core-3.8.1.gem',
               '/build/spec/fixtures/httparty-0.17.0.gem' ]

      yank_if_exist('rspec-core', '3.8.1')
      yank_if_exist('httparty', '0.17.0')

      ret = cli_push_test('https://apt.fury.io/cli/', gems.join(' '))
      expect(ret).to be_truthy

      line_groups = parse_out_file
      lines = line_groups[2]

      i = 0
      gems.each do |gem|
        expect(lines[i]).to match(/Uploading #{File.basename(gem)}.+\- done/)
        i += 1
      end
    end

    private

    def yank_if_exist(gem, version)
      begin
        ret = @fury.yank_version(gem, version)
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

      expect(lines[0]).to eq('You are logged in as "furynix"')
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
      container.runi(:exec => '"/build/spec/exec/cli_list_test %s %s %s"' %
                              [ FurynixSpec.calculate_build_path(@out_file_path),
                                source,
                                ENV['FURYNIX_API_TOKEN']
                              ])
    end

    def cli_push_test(source, gem)
      container.runi(:exec => '"/build/spec/exec/cli_push_test %s %s %s \"%s\""' %
                              [ FurynixSpec.calculate_build_path(@out_file_path),
                                source,
                                ENV['FURYNIX_API_TOKEN'],
                                gem
                              ])
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
