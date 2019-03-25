module Nfe
  module ApiOperations
    module Retrieve
      def retrieve(obj_id)
        obj_id = "?id=#{obj_id}" if obj_id.include? '@'
        response = api_request endpoint: "#{endpoint}/#{obj_id}",
          method: :get, api_version: api_version
        create_from response
      end

      def self.included(base)
        base.extend Retrieve
      end
    end
  end
end
