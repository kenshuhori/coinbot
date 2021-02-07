require('dotenv').config()

const key = process.env.api_key
const secret = process.env.api_secret

const url = require('url')

const uri = url.parse("https://coincheck.com/api/accounts/balance")

const date = new Date()
const nonce = date.getTime()

const message = `${nonce}${uri.href}`

const crypto = require('crypto')
const signature = crypto.createHmac('sha256', secret)
  .update(message)
  .digest('hex')


const axios = require('axios')

// 残高確認
// axios.get(uri.href, {
//   headers: {
//     "ACCESS-KEY": key,
//     "ACCESS-NONCE": nonce,
//     "ACCESS-SIGNATURE": signature
//   }
// })
//   .then(res => {
//     console.log(res)
//   })

// const getOrderBooksData = async () => {
//   const ticker = "BTC"
// }


const getData = () => {
  axios.get(`https://coincheck.com/api/ticker`)
  .then(res => {
    console.log(res.data.last) // last: 最後の取引の価格
  })
}

// 1 秒おきに実行
setInterval(() => {
  getData()
}, 1000);
