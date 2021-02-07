require('dotenv').config()

const key = process.env.api_key
const secret = process.env.api_secret
const url = require('url')
const crypto = require('crypto')

const axios = require('axios')
const { rejects } = require('assert')
const { resolve } = require('path')

async function execute() {
  // callApi('/api/accounts/balance', 'get')
  let ticker = await callApi('/api/ticker', 'get');
  console.log(ticker.last);
}

async function callApi(path, method) {
  const baseUrl = 'https://coincheck.com';
  let uri = url.parse(baseUrl + path);
  let nonce = new Date().getTime();
  let message = `${nonce}${uri.href}`;
  let signature = crypto.createHmac('sha256', secret).update(message).digest('hex');
  let headers = {
    "ACCESS-KEY": key,
    "ACCESS-NONCE": nonce,
    "ACCESS-SIGNATURE": signature
  };
  if (method == 'get') {
    const res = await axios.get(uri.href, {headers: headers})
    return res.data
  } else if (method == 'post') {
    console.log('未実装')
  }
}

setInterval(execute, 2000)
