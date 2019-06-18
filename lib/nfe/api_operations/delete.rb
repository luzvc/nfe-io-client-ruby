module Nfe
  module ApiOperations
    module Delete
      def delete(id)
        endpoint = "#{self.endpoint}/#{id}"
        response = api_request endpoint: endpoint, method: :delete,
          api_version: api_version
        response.nil? ? true : response
      end

      def self.included(base)
        base.extend Delete
      end
    end
  end
end
