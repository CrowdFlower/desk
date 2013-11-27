require 'faraday_middleware'
require 'faraday/request/multipart_with_file'
require 'faraday/response/raise_http_4xx'
require 'faraday/response/raise_http_5xx'

module Desk
  # @private
  module Connection
    private

    def connection(raw=false)
      options = {
        :headers => {'Accept' => "application/json", 'User-Agent' => user_agent},
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => api_endpoint,
      }

      Faraday.new(options) do |builder|
        builder.use FaradayMiddleware::EncodeJson
        builder.use Faraday::Request::MultipartWithFile
        builder.use Faraday::Request::OAuth, authentication if authenticated?
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::RaiseHttp4xx
        unless raw
          builder.use Faraday::Response::Rashify
          builder.use Faraday::Response::ParseJson
        end
        builder.use Faraday::Response::RaiseHttp5xx
        builder.adapter(adapter)
      end
    end
  end
end
