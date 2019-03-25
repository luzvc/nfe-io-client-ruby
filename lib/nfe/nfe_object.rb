module Nfe
  class NfeObject
    include Nfe::ApiVersion

    attr_accessor :values

    class << self
      def create_from(params)
        obj = self.new
        obj.reflesh_object(params)
      end

      def endpoint
        "/#{CGI.escape(class_name.downcase)}s"
      end

      def class_name
        self.name.split('::')[-1]
      end
    end

    def endpoint
      "#{self.class.endpoint}/#{self.id}"
    end

    def initialize()
      @values = {}
    end

    def metaclass
      class << self; self; end
    end

    def reflesh_object(params)
      params = create_list(params) if params.class == Array
      create_fields(params)
      set_properties(params)
      self
    end

    def create_fields(params)
      instance_eval do
        metaclass.instance_eval do
          params.keys.each do |key|
            define_method(key) { @values[key] }

            define_method("#{key}=") do |value|
              @values[key] = value
            end
          end
        end
      end
    end

    def set_properties(params)
      instance_eval do
        params.each do |key, value|
          if value.class == Hash
            @values[key] = Util.get_object_type(value['object']).create_from(value)
          elsif value.class == Array
            @values[key] = value.map{ |v| Util.get_object_type(v['object']).create_from(v) }
          else
            @values[key] = value
          end
        end
      end
    end

    def create_list(array)
      hash = {}
      hash[:data] = array
      hash[:object] = 'list'
      hash
    end

    def method_missing(name, *args)
      if name.to_s.end_with? '='
        name = name.to_s[0...-1].to_sym
      end

      if serialize_params.include? name
        @values[name] = args[0]
      else
        raise NoMemoryError.new ("Cannot set #{name} on this object")
      end
    end

    def to_hash
      @values.inject({}) do |result, (key,value)|
        if value.is_a? Array
          list = []
          value.each do |obj|
            list.push(obj.respond_to?(:to_hash) ? obj.to_hash : value)
          end
          result[key] = list
        else if value.respond_to?(:to_hash)
               result[key] = value.to_hash
             else
               result[key] =  value
             end
        end
        result
      end
    end

    def to_json(*a)
      JSON.generate(@values)
    end

    def to_s
      JSON.generate(@values)
    end
  end
end
