module Nfe
  class Company < NfeObject
    include ApiResource
    include ApiOperations::Create
    include ApiOperations::List
    include ApiOperations::Retrieve
    include ApiOperations::Delete
    include ApiOperations::Update

    api :v2

    def self.endpoint
      "/companies"
    end

    def endpoint
      "#{self.class.endpoint}/#{self.id}"
    end

    def self.create_from(params)
      obj = self.new
      obj.reflesh_object(params["companies"])
    end
  end
end
