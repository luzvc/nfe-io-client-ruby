module Nfe
  module ApiOperations
    module List
      def list_all(params=nil)
        response = api_request endpoint: endpoint, method: :get,
          params: params, api_version: api_version
        create_list_from response
      end

      def self.included(base)
        base.extend List
      end
    end
  end
end
