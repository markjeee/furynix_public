require_relative '../spec_helper'

describe 'Gemfury API' do
  context 'Package info' do
    before do
      @fury = FurynixSpec.gemfury_client
    end

    it 'should return package info' do
      prepare_gemfury_gem
      package = @fury.package_info('gemfury')['package']
      expect(package['name']).to eq('gemfury')
    end

    it 'should update privacy to public' do
      prepare_gemfury_gem
      package = @fury.update_privacy('gemfury', false)['package']
      expect(package['private']).to_not be_truthy
    end

    def prepare_gemfury_gem
      begin
        @fury.package_info('gemfury')['package']
      rescue Gemfury::NotFound
        f = File.new(File.join(FurynixSpec.fixtures_path, 'gemfury-0.11.0.rc1.gem'))
        @fury.push_gem(f)
      end
    end
  end
end
