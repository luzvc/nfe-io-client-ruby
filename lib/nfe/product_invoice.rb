module Nfe
  class ProductInvoice < NfeObject
    include ApiResource
    include ApiOperations::Create
    include ApiOperations::List
    include ApiOperations::Retrieve
    include ApiOperations::Cancel
    include ApiOperations::Download

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
