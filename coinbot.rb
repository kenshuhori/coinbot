require 'logger'
require './asset_manager'

def executor(asset_manager, minutes)
  logger = Logger.new('logs/result.log')
  start_time = Time.now
  loop do
    # 一週間回す
    # if (Time.now - start_time)/60/60/24 > 7
    #   p "一週間経過したため終了します"
    #   break
    # end

    # 1分回す
    if (Time.now - start_time) > (60 * minutes)
      p "1分経過したため終了します"
      break
    end
    p asset_manager.executions("BTC_JPY").first
    logger.info(asset_manager.executions("BTC_JPY").first)
    # asset_manager.market_buy("BTC_JPY")
    sleep 3 # 3秒停止
  end
end

asset_manager = AssetManager.new
minutes = 2
executor(asset_manager, minutes)
