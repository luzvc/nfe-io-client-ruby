module Nfe
  class ServiceInvoice < NfeObject
    include ApiResource
    include ApiOperations::Create
    include ApiOperations::List
    include ApiOperations::Retrieve
    include ApiOperations::Cancel
    include ApiOperations::Update
    include ApiOperations::Download

    api :v1

    def self.company_id(company_id)
      @company_id = company_id
    end

    def self.endpoint
      "/companies/#{@company_id}/serviceinvoices"
    end

    def endpoint
      self.class.endpoint
    end

    def self.create_from(params)
      params
    end
  end
end
