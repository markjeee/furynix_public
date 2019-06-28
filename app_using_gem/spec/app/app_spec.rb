require_relative '../spec_helper'

describe 'App initialization' do
  context 'gem_using_bundler' do
    it 'should load gem_using_bundler properly' do
      expect(AppUsingGem.method_in_gem).to eq('I am a method in Gem')
    end
  end
end
