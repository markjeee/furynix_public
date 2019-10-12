module GemUsingBundler
  if ENV.include?('GEM_USING_BUNDLER_VERSION')
    VERSION = '0.1.1'
  else
    VERSION = '0.1.0'
  end
end
