module Nfe
  class NaturalPeople < NfeObject
    include ApiResource
    include ApiOperations::List
    include ApiOperations::Retrieve

    api :v1

    def self.company_id(company_id)
      @company_id = company_id
    end

    def self.endpoint
      "/companies/#{@company_id}/naturalpeople"
    end

    def endpoint
      "#{self.class.endpoint}/#{self.id}"
    end

    def self.create_from(params)
      obj = self.new
      obj.reflesh_object(params["naturalPeople"])
    end
  end
end
