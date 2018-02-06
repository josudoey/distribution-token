const Token = artifacts.require('SimpleToken')
const ICO = artifacts.require('InitialCoinOffering')
const assert = require('assert')

contract('InitialCoinOffering', function (accounts) {
  let token
  let ico
  const owner = web3.eth.accounts[0]
  const issuer = web3.eth.accounts[1]
  const initailSupply = 10

  before(async function () {
    token = await Token.new()
    ico = await ICO.new(token.address, issuer, initailSupply)
    await token.trust(ico.address)
  })

  it('initial case', async function () {
    await ico.initial()
    const balance = await token.balanceOf(issuer)
    assert(balance.toString() === initailSupply.toString())
  })
})

