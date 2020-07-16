RSpec.describe GemForRepo do
  it 'has a version number' do
    expect(GemForRepo::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(GemForRepo.method_in_gem).to eq('I am a method in Gem')
  end
end
