module Nfe
  module ApiOperations
    module Update
      def save
        params_to_update = {}

        self.serialize_params.each do |key|
          return if (@values[key] || @values[key.to_s]).is_a? Nfe::NfeObject
          params_to_update[key] = (@values[key] || @values[key.to_s]) if @values
        end

        update params_to_update
      end

      def update(params=nil, endpoint_sufix=nil)
        response = api_request endpoint: "#{endpoint}/#{endpoint_sufix}",
          method: :post, params: params, api_version: api_version

        reflesh_object response
      end
    end
  end
end
