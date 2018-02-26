const Token = artifacts.require('SimpleToken')
const ICO = artifacts.require('InitialCoinOffering')
const RestrictingSale = artifacts.require('RestrictingSale')
const assert = require('assert')
const Eth = require('ethjs')
const util = require('ethereumjs-util')
const eth = new Eth(web3.currentProvider)

contract('RestrictingSale', function (accounts) {
  let token
  let ico
  let saleContract
  //private key see http://truffleframework.com/docs/getting_started/console#truffle-develop
  const owner = web3.eth.accounts[0]
  const issuer = web3.eth.accounts[1]
  const inspector = web3.eth.accounts[2]
  const inspectorKey = Buffer.from('0dbbe8e4ae425a6d2687f1a7e3ba17bc98c673636790f1b8ad91193c05875ef1', 'hex')
  const guest = web3.eth.accounts[3]
  const initailSupply = 10000

  before(async function () {
    token = await Token.new()
    ico = await ICO.new(token.address, issuer, initailSupply)
    await token.trust(ico.address)
  })

  it('initial case', async function () {
    await ico.initial()
    let tokenBalance = await token.balanceOf(issuer)
    assert(tokenBalance.toString() === initailSupply.toString())
    const rate = 10
    saleContract = await RestrictingSale.new(token.address, rate, {
      from: issuer
    })

    await token.transfer(saleContract.address, 10000, {
      from: issuer
    })

    const saleAmount = await token.balanceOf(saleContract.address)
    assert(saleAmount.toString() === '10000')

    tokenBalance = await token.balanceOf(issuer)
    assert(tokenBalance.toString() === '0')


    await saleContract.transferInspector(inspector, {
      from: issuer
    })


  })

  it('base sale case', async function () {
    let beforeBalance = await eth.getBalance(issuer)
    const hash = util.sha3(Buffer.from(guest.replace(/^0x/, ''), 'hex'))
    let signature = util.ecsign(hash, inspectorKey)
    let vTicket = '0x' + Buffer.from([signature.v]).toString('hex')
    let rTicket = '0x' + signature.r.toString('hex')
    let sTicket = '0x' + signature.s.toString('hex')
    const verified = await saleContract.hasVerified(guest, vTicket, rTicket, sTicket)
    assert(verified)

    const tx = await saleContract.buyTokens(guest, vTicket, rTicket, sTicket, {
      from: guest,
      value: 20,
      gas: 3000000
    })

    let remaining = await saleContract.remaining()
    assert(remaining.toString() === '9800')

    const guestBalance = await token.balanceOf(guest)
    assert(guestBalance.toString() === '200')

    let afterBalance = await eth.getBalance(issuer)

    assert(afterBalance.sub(beforeBalance).toString() === '20')

  })

})

