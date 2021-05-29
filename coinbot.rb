require './asset_manager'

asset_manager = AssetManager.new
start_time = Time.now
loop do
  # 一週間回す
  # if (Time.now - start_time)/60/60/24 > 7
  #   p "一週間経過したため終了します"
  #   break
  # end

  # 1分回す
  if (Time.now - start_time) > 60
    p "1分経過したため終了します"
    break
  end
  p asset_manager.executions("BTC_JPY").first
  sleep 3 # 3秒停止
end

# child_order_id = asset_manager.my_executions("BTC_JPY").first["child_order_id"]
# asset_manager.market_buy()
# available = asset_manager.btc["available"]
# p available
# asset_manager.market_sell(available)
# asset_manager.cancel_order("BTC_JPY", child_order_id)
