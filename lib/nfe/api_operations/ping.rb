module Nfe
  module ApiOperations
    module Ping
      def ping
        response = api_request endpoint: endpoint, method: :put,
          api_version: api_version

        response.nil? ? true : response
      end
    end
  end
end
