require 'logger'
require './asset_manager'

def executor(asset_manager)
  logger = Logger.new('logs/result.log')
  start_time = Time.now
  latest_prices = Array.new(10)

  loop do
    # 1週間回す
    if (Time.now - start_time)/60/60/24 > 7
      p "1週間経過したため終了します"
      break
    end

    latest_prices.shift(1)
    latest_prices.push(asset_manager.executions("BTC_JPY").first["price"])
    p latest_prices
    # logger.info(asset_manager.executions("BTC_JPY").first)
    # asset_manager.market_buy("BTC_JPY")
    sleep 6
  end
end

asset_manager = AssetManager.new
executor(asset_manager)
