module Nfe
  class Webhook < NfeObject
    include ApiResource
    include ApiOperations::Create
    include ApiOperations::List
    include ApiOperations::Retrieve
    include ApiOperations::Delete
    include ApiOperations::Update
    include ApiOperations::Ping

    api :v2

    def self.company_id(company_id)
      @company_id = company_id
    end

    def self.endpoint
      "/companies/#{@company_id}/productinvoices"
    end

    def endpoint
      self.class.endpoint
    end

    def self.create_from(params)
      params
    end
  end
end
