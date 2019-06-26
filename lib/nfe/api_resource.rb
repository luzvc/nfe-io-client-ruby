module Nfe
  module ApiResource
    SSL_BUNDLE_PATH = File.dirname(__FILE__) + '/../data/ssl-bundle.crt'

    def url_encode(key)
      URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def encode(params)
      params.map { |k,v| "#{k}=#{url_encode(v)}" }.join('&')
    end

    def api_request(endpoint:, method:, params: nil, api_version: :v1)
      url = "#{Nfe.configuration.base_url(api_version)}#{endpoint}"
      api_key = Nfe.access_keys

      if method == :get && params
        params_encoded = encode(params)
        url = "#{url}?#{params_encoded}"
        params = nil
      end

      payload = (params != nil) ? params.to_json : ''
      request = RestClient::Request.new(
                  method: method,
                  url: url,
                  payload: payload,
                  headers: {
                    content_type: 'application/json',
                    accept: 'application/json',
                    authorization: api_key,
                    user_agent: Nfe.configuration.user_agent
                  })

      begin
        response = request.execute
        JSON.parse(response.to_s) unless response.to_s.empty?
      rescue RestClient::ExceptionWithResponse => e
        if rcode = e.http_code and rbody = e.http_body
          rbody = JSON.parse(rbody)
          rbody = Util.symbolize_names(rbody)

          raise NfeError.new(rcode, rbody, rbody, rbody[:message])
        else
          raise e
        end
      rescue RestClient::Exception => e
        raise e
      end
    end

    def self.included(base)
      base.extend(ApiResource)
    end

    def api_request_file(endpoint:, method:, params: nil)
      api_key = Nfe.access_keys
      url = "#{Nfe.configuration.base_url(api_version)}#{endpoint}?api_key=#{api_key}"

      request = RestClient::Request.new(
        method: method,
        url: url,
        headers: { user_agent: Nfe.configuration.user_agent }
      )

      begin
        response = request.execute
        JSON.parse(response.to_s) unless response.to_s.empty?
      rescue RestClient::ExceptionWithResponse => e
        if rcode = e.http_code and rbody = e.http_body
          rbody = JSON.parse(rbody)
          rbody = Util.symbolize_names(rbody)

         raise NfeError.new(rcode, rbody, rbody, rbody[:message])
        else
          raise e
        end
      rescue RestClient::Exception => e
        raise e
      end
    end
  end
end
