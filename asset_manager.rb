require 'yaml'
require "net/http"
require "uri"
require "openssl"
require 'json'
require './bit_flyer_api'

class AssetManager
  attr_reader :key, :secret
  attr_accessor :balance

  def initialize
    @key = api_key()
    @secret = api_secret()
    @balance = balance()
  end

  def api_key
    file = open("apikey.yml", "r") { |f| YAML.load(f) }
    file["api_key"]
  end

  def api_secret
    file = open("apikey.yml", "r") { |f| YAML.load(f) }
    file["api_secret"]
  end

  def balance
    uri = URI.parse("https://api.bitflyer.jp")
    uri.path = "/v1/me/getbalance"

    BitFlyerApi.call_api(@key, @secret, "GET", uri)
  end

  def xrp
    @balance.select { |brand| brand["currency_code"] == "XRP" }[0]
  end

  def xem
    @balance.select { |brand| brand["currency_code"] == "XEM" }[0]
  end
end

asset_manager = AssetManager.new
p asset_manager.xrp
p asset_manager.xem
