require 'gem_using_bundler'

module AppUsingGem
  def self.method_in_gem
    GemUsingBundler.method_in_gem
  end
end
