module Nfe
  module ApiOperations
    module Create
      def create(params)
        response = api_request endpoint: endpoint, method: :post,
          params: params, api_version: api_version
        create_from response
      end

      def self.included(base)
        base.extend Create
      end
    end
  end
end
