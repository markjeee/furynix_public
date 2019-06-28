require 'gemfury'

module Furynix
  module GemfuryAPI
    def self.client(options = { })
      @client = Gemfury::Client.new(options)
      @client.send(:extend, ClientExtensions)
      @client
    end

    module ClientExtensions
      def package_info(package_name, options = { })
        ensure_ready!(:authorization)
        url = 'packages/%s' % escape(package_name)

        response = connection(:api_version => 2).get(url, options)
        checked_response_body(response)
      end

      def update_privacy(package_name, priv = true, options = { })
        ensure_ready!(:authorization)

        package = package_info(package_name)['package']
        url = 'packages/%s' % escape(package['id'])
        body = { 'package' => { 'private' => priv } }

        response = connection(:api_version => 2).put(url, body, options)
        checked_response_body(response)
      end
    end
  end
end
