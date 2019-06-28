require_relative '../spec_helper'

describe 'Gemfury API' do
  context 'Package info' do
    before do
      @fury = FurynixSpec.gemfury_client
    end

    it 'should return package info' do
      package = @fury.package_info('gem_using_bundler')['package']
      expect(package['name']).to eq('gem_using_bundler')
    end

    it 'should update privacy to public' do
      package = @fury.update_privacy('gem_using_bundler', false)['package']
      expect(package['private']).to_not be_truthy
    end
  end
end
