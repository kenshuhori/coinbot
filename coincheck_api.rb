require 'yaml'
require "net/http"
require "uri"
require "openssl"
require 'json'

class CoincheckApi
  def initialize
    @key = api_key()
    @secret = api_secret()
  end

  def api_key
    file = open("coincheck_apikey.yml", "r") { |f| YAML.load(f) }
    file["api_key"]
  end

  def api_secret
    file = open("coincheck_apikey.yml", "r") { |f| YAML.load(f) }
    file["api_secret"]
  end

  def call_api
    key = @key
    secret = @secret
    uri = URI.parse "https://coincheck.com/api/accounts/balance"
    nonce = Time.now.to_i.to_s
    message = nonce + uri.to_s
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, message)
    headers = {
      "ACCESS-KEY" => key,
      "ACCESS-NONCE" => nonce,
      "ACCESS-SIGNATURE" => signature
    }

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.start {
      https.get(uri.request_uri, headers)
    }

    puts response.body
  end
end

CoincheckApi.new.call_api
