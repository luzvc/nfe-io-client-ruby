module Nfe
  module ApiOperations
    module Download
      def download(nfe_id, file_format)
        if file_format != :pdf && file_format != :xml
          rcode = '422'
          message = 'Invalid file format. Only :pdf or :xml are supported'
          formatted = { error: message }
          raise NfeError.new(rcode, formatted, formatted, message)
        else
          endpoint = "#{self.endpoint}/#{nfe_id}/#{file_format}"
          api_request_file(endpoint: endpoint, method: :get)
        end
      end

      def self.included(base)
        base.extend(Download)
      end
    end
  end
end
