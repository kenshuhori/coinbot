require "net/http"
require "uri"
require "openssl"
require 'json'

class BitFlyerApi
  def self.call_api(key, secret, method, uri, body="")
    timestamp = Time.now.to_i.to_s

    text = timestamp + method + uri.request_uri + body
    sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

    options = if method == "GET"
                Net::HTTP::Get.new(uri.request_uri, initheader = {
                  "ACCESS-KEY" => key,
                  "ACCESS-TIMESTAMP" => timestamp,
                  "ACCESS-SIGN" => sign,
                });
              else
                Net::HTTP::Post.new(uri.request_uri, initheader = {
                  "ACCESS-KEY" => key,
                  "ACCESS-TIMESTAMP" => timestamp,
                  "ACCESS-SIGN" => sign,
                  "Content-Type" => "application/json"
                });
              end
    options.body = body if body != ""

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.request(options)

    JSON.parse(response.body)
  end
end
