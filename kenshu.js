require('dotenv').config()

const key = process.env.api_key
const secret = process.env.api_secret

var CoinCheck = require('./node_modules/coincheck/src/coin_check.js');
var coinCheck = new CoinCheck.CoinCheck(process.env.api_key, process.env.api_secret);

var params = {
    options: {
        success: function(data, response, params) {
            console.log('success', data);
        },
        error: function(error, response, params) {
            console.log('error', error);
        }
    }
};

/** Public API */
coinCheck.ticker.all(params);
// coinCheck.trade.all(params);
coinCheck.orderBook.all(params);

/** Private API */

// 新規注文
// "buy" 指値注文 現物取引 買い
// "sell" 指値注文 現物取引 売り
// "market_buy" 成行注文 現物取引 買い
// "market_sell" 成行注文 現物取引 売り
// "leverage_buy" 指値注文 レバレッジ取引新規 買い
// "leverage_sell" 指値注文 レバレッジ取引新規 売り
// "close_long" 指値注文 レバレッジ取引決済 売り
// "close_short" 指値注文 レバレッジ取引決済 買い
params['data'] = {
    rate: 2850,
    amount: 0.00508771,
    order_type: 'buy',
    pair: 'btc_jpy'
}

// 未決済の注文一覧
coinCheck.order.opens(params);
