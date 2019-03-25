module Nfe
  module ApiOperations
    module Cancel
      def cancel(nfe_id)
        response = api_request endpoint: "#{endpoint}/#{nfe_id}",
          method: :delete, api_version: api_version
        create_from response
      end

      def self.included(base)
        base.extend Cancel
      end
    end
  end
end
