const Token = artifacts.require('SimpleToken')
const ICO = artifacts.require('InitialCoinOffering')
const CrowdSale = artifacts.require('CrowdSale')
const assert = require('assert')
const Eth = require('ethjs')
const eth = new Eth(web3.currentProvider)

contract('CrowdSale', function (accounts) {
  let token
  let ico
  let crowdsale
  const owner = web3.eth.accounts[0]
  const issuer = web3.eth.accounts[1]
  const guest = web3.eth.accounts[2]
  const initailSupply = 10000

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

  it('base sale case', async function () {
    const rate = 10
    crowdsale = await CrowdSale.new(token.address, rate)
    await token.transfer(crowdsale.address, 1000, {
      from: issuer
    })
    const balance = await token.balanceOf(issuer)
    assert(balance.toString() === '9000')

    const tx = await eth.sendTransaction({
      from: guest,
      to: crowdsale.address,
      value: 20,
      gas: 3000000,
      data: '0x'
    })

    let remaining = await crowdsale.remaining()
    assert(remaining.toString() === '800')

    const guestBalance = await token.balanceOf(guest)
    assert(guestBalance.toString() === '200')

  })

})

