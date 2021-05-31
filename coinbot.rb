require 'logger'
require 'mysql2'
require 'date'
require './asset_manager'

class Coinbot
  def initialize()
    @logger = Logger.new('logs/result.log')
    @product_code = "BTC_JPY"
    @client = Mysql2::Client.new(
      host: ENV['MYSQL_HOST'],
      username: ENV['MYSQL_USER'],
      password: ENV['MYSQL_PASSWORD'],
      :encoding => ENV['MYSQL_ENCODING'],
      database: ENV['MYSQL_DATABASE']
    )
    sql = %{
      SELECT * FROM conversions ORDER BY created_at DESC LIMIT 1;
    }
    statement = @client.prepare(sql)
    results = statement.execute()
    @side = results.first['side'] == "BUY" ? "SELL" : "BUY"
    @buy_price = @side == 'SELL' ? results.first['price'] : 0
    @asset_manager = AssetManager.new
  end

  def executor()
    start_time = Time.now
    latest_prices = Array.new(2)
    loop do
      # 5日間回す
      if (Time.now - start_time)/60/60/24 > 5
        p "5日間経過したため終了します"
        break
      end

      current_data = @asset_manager.executions(@product_code).first
      log_price(current_data)
      latest_prices.shift(1)
      latest_prices.push(current_data["price"])
      convert_now if check_conversion(latest_prices[0], latest_prices[1])
      sleep 60
    end
  end

  def check_execution(child_order_acceptance_id)
    cvrs = []
    loop do
      cvrs = @asset_manager.my_executions(@product_code, child_order_acceptance_id)
      break unless cvrs.empty?
    end
    cvrs.filter{ |cvr| cvr['child_order_acceptance_id'] == child_order_acceptance_id }
  end

  def check_conversion(previous_price, current_price)
    return false if previous_price.nil? || current_price.nil?

    if @side == "BUY"
      return true if current_price > previous_price
    elsif @side == "SELL"
      return true if current_price < previous_price && current_price > @buy_price
    end
    false
  end

  def convert_now
    response = if @side == "BUY"
                 @asset_manager.market_buy(@product_code)
               elsif @side == "SELL"
                 @asset_manager.market_sell(@product_code)
               end
    cvr = check_execution(response['child_order_acceptance_id'])
    sql = %{
      INSERT INTO conversions (product_code, child_order_id, price, size, type, side, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    }
    statement = @client.prepare(sql)
    exec_date = DateTime.parse(cvr.first['exec_date']).to_time + 32400
    statement.execute(@product_code, cvr.first['child_order_id'], cvr.first['price'], cvr.first['size'], "MARKET", cvr.first['side'], exec_date, Time.now)
    @buy_price = cvr.first['price'] if @side == "BUY"
    switch_side()
  end

  def switch_side
    if @side == "BUY"
      @side = "SELL"
    else
      @side = "BUY"
    end
  end

  def log_price(current_data)
    sql = %{
      INSERT INTO prices (product_code, price, created_at, updated_at) VALUES (?, ?, ?, ?)
    }
    statement = @client.prepare(sql)
    statement.execute(@product_code, current_data["price"], Time.now, Time.now)
    @logger.info(current_data)
  end
end

Coinbot.new.executor()
