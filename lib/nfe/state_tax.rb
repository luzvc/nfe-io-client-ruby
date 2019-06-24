module Nfe
  class StateTax < NfeObject
    include ApiResource
    include ApiOperations::List
    include ApiOperations::Create
    include ApiOperations::Retrieve
    include ApiOperations::Update
    include ApiOperations::Delete

    api :v2

    def self.company_id(company_id)
      @company_id = company_id
    end

    def self.endpoint
      "/companies/#{@company_id}/statetaxes"
    end

    def endpoint
      self.class.endpoint
    end

    def self.create_from(params)
      params
    end

    def self.create_list_from(params)
      obj = self.new
      obj.reflesh_object(params["stateTaxes"])
    end
  end
end
