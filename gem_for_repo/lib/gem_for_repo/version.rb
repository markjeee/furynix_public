module GemForRepo
  if ENV.include?('GEM_FOR_REPO_VERSION')
    VERSION = '0.1.1'
  else
    VERSION = '0.1.0'
  end
end
