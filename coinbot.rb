require 'logger'
require 'mysql2'
require './asset_manager'

def executor(asset_manager)
  logger = Logger.new('logs/result.log')
  product_code = "BTC_JPY"
  start_time = Time.now
  client = Mysql2::Client.new(
    host: ENV['MYSQL_HOST'],
    username: ENV['MYSQL_USER'],
    password: ENV['MYSQL_PASSWORD'],
    :encoding => ENV['MYSQL_ENCODING'],
    database: ENV['MYSQL_DATABASE']
  )
  latest_prices = Array.new(10)

  loop do
    # 1週間回す
    if (Time.now - start_time)/60/60/24 > 7
      p "1週間経過したため終了します"
      break
    end

    current_price = asset_manager.executions(product_code).first["price"]
    latest_prices.shift(1)
    latest_prices.push(current_price)
    sql = %{
      INSERT INTO prices (product_code, price, created_at, updated_at) VALUES (?, ?, ?, ?)
    }
    statement = client.prepare(sql)
    response = statement.execute(product_code, current_price, Time.now, Time.now)
    # logger.info(asset_manager.executions(product_code).first)
    # asset_manager.market_buy(product_code)
    sleep 6
  end
end

asset_manager = AssetManager.new
executor(asset_manager)
