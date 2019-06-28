RSpec.describe GemUsingBundler do
  it 'has a version number' do
    expect(GemUsingBundler::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(GemUsingBundler.method_in_gem).to eq('I am a method in Gem')
  end
end
