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
    @bit_flyer_api = BitFlyerApi.new
    @balance = @bit_flyer_api.balance()
  end

  def markets
    @bit_flyer_api.markets
  end

  def my_executions(product_code)
    @bit_flyer_api.my_executions(product_code)
  end

  def executions(product_code)
    @bit_flyer_api.executions(product_code)
  end

  def commision_rate(product_code)
    @bit_flyer_api.commision_rate(product_code)
  end

  def market_buy()
    @bit_flyer_api.market_buy()
  end

  def market_sell()
    @bit_flyer_api.market_sell()
  end

  def cancel_order(product_code, child_order_id)
    @bit_flyer_api.cancel_order(product_code, child_order_id)
  end

  def jpy
    @balance.select { |brand| brand["currency_code"] == "JPY" }[0]
  end

  def btc
    @balance.select { |brand| brand["currency_code"] == "BTC" }[0]
  end

  def bch
    @balance.select { |brand| brand["currency_code"] == "BCH" }[0]
  end

  def eth
    @balance.select { |brand| brand["currency_code"] == "ETH" }[0]
  end

  def etc
    @balance.select { |brand| brand["currency_code"] == "ETC" }[0]
  end

  def ltc
    @balance.select { |brand| brand["currency_code"] == "LTC" }[0]
  end

  def mona
    @balance.select { |brand| brand["currency_code"] == "MONA" }[0]
  end

  def lsk
    @balance.select { |brand| brand["currency_code"] == "LSK" }[0]
  end

  def xrp
    @balance.select { |brand| brand["currency_code"] == "XRP" }[0]
  end

  def bat
    @balance.select { |brand| brand["currency_code"] == "BAT" }[0]
  end

  def xlm
    @balance.select { |brand| brand["currency_code"] == "XLM" }[0]
  end

  def xem
    @balance.select { |brand| brand["currency_code"] == "XEM" }[0]
  end

  def xtz
    @balance.select { |brand| brand["currency_code"] == "XTZ" }[0]
  end
end
