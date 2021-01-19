require "net/http"
require "uri"
require "openssl"
require 'json'

class BitFlyerApi
  def initialize
    @key = api_key()
    @secret = api_secret()
  end

  def api_key
    file = open("apikey.yml", "r") { |f| YAML.load(f) }
    file["api_key"]
  end

  def api_secret
    file = open("apikey.yml", "r") { |f| YAML.load(f) }
    file["api_secret"]
  end

  def call_api(method, uri, body="")
    timestamp = Time.now.to_i.to_s

    text = timestamp + method + uri.request_uri + body
    sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), @secret, text)

    options = if method == "GET"
                Net::HTTP::Get.new(uri.request_uri, initheader = {
                  "ACCESS-KEY" => @key,
                  "ACCESS-TIMESTAMP" => timestamp,
                  "ACCESS-SIGN" => sign,
                });
              else
                Net::HTTP::Post.new(uri.request_uri, initheader = {
                  "ACCESS-KEY" => @key,
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

  def markets
    uri = URI.parse("https://api.bitflyer.com")
    uri.path = '/v1/markets'

    call_api("GET", uri)
  end

  def balance
    uri = URI.parse("https://api.bitflyer.jp")
    uri.path = "/v1/me/getbalance"

    call_api("GET", uri)
  end

  def executions(product_code)
    uri = URI.parse("https://api.bitflyer.jp")
    uri.path = "/v1/executions"
    uri.query = "product_code=#{product_code}"

    call_api("GET", uri)
  end
end
