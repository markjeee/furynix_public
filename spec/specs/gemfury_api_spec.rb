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
  end
end
