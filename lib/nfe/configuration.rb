module Nfe
  class Configuration
    attr_accessor :user_agent

    API_URL = {
      v1: "https://api.nfe.io/v1",
      v2: "https://api.nfse.io/v2"
    }.freeze

    def initialize
      @user_agent = "NFe.io Ruby Client v#{Nfe::VERSION}"
    end

    def base_url(version = :v1)
      API_URL[version]
    end
  end
end
