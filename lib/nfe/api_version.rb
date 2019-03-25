module Nfe
  module ApiVersion
    module ClassMethods
      attr_accessor :api_version

      def api(version)
        @api_version = version
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
