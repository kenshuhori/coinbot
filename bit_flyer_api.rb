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

  def uri
    URI.parse("https://api.bitflyer.com")
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
              elsif method == "POST"
                Net::HTTP::Post.new(uri.request_uri, initheader = {
                  "ACCESS-KEY" => @key,
                  "ACCESS-TIMESTAMP" => timestamp,
                  "ACCESS-SIGN" => sign,
                  "Content-Type" => "application/json"
                });
              else
                raise Exception("想定外のHTTPメソッドです。GETまたはPOSTを指定してください。")
              end
    options.body = body if body != ""

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.request(options)

    if response.msg == "OK"
      JSON.parse(response.body)
    else
      "エラー発生！！！"
    end
  end

  def markets
    uri = uri()
    uri.path = '/v1/markets'

    call_api("GET", uri)
  end

  def balance
    uri = uri()
    uri.path = "/v1/me/getbalance"

    call_api("GET", uri)
  end

  def my_executions(product_code)
    uri = uri()
    uri.path = "/v1/me/getexecutions"
    uri.query = "product_code=#{product_code}"

    call_api("GET", uri)
  end

  def executions(product_code)
    uri = uri()
    uri.path = "/v1/executions"
    uri.query = "product_code=#{product_code}"

    call_api("GET", uri)
  end

  def commision_rate(product_code)
    uri = uri()
    uri.path = "/v1/me/gettradingcommission"
    uri.query = "product_code=#{product_code}"

    call_api("GET", uri)
  end

  def market_buy(product_code)
    body = {
      "product_code": product_code,
      "child_order_type": "MARKET",
      "side": "BUY",
      "size": 0.001,
      "minute_to_expire": 60,
      "time_in_force": "GTC"
    }.to_json
    order(body)
  end

  def market_sell(product_code)
    body = {
      "product_code": product_code,
      "child_order_type": "MARKET",
      "side": "SELL",
      "size": 0.001,
      "minute_to_expire": 60,
      "time_in_force": "GTC"
    }.to_json
    order(body)
  end

  def cancel_order(product_code, child_order_id)
    uri = uri()
    uri.path = "/v1/me/cancelchildorder"
    body = {
      "product_code": product_code,
      "child_order_id": child_order_id
    }.to_json

    call_api("POST", uri, body)
  end

  private

  def order(body)
    uri = uri()
    uri.path = "/v1/me/sendchildorder"

    call_api("POST", uri, body)
  end
end
