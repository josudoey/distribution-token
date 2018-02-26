const Verifiable = artifacts.require('Verifiable')
const assert = require('assert')
const Eth = require('ethjs')
const util = require('ethereumjs-util')
const eth = new Eth(web3.currentProvider)

contract('Verifiable', function (accounts) {
  //private key see http://truffleframework.com/docs/getting_started/console#truffle-develop
  let contract
  const owner = web3.eth.accounts[0]
  const ownerKey = Buffer.from('c87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3', 'hex')
  const inspector = web3.eth.accounts[1]
  const inspectorKey = Buffer.from('ae6ae8e5ccbfb04590405997ee2d52d2b330726137b875053c36d94e974d162f', 'hex')
  const guest = web3.eth.accounts[2]

  before(async function () {
    contract = await Verifiable.new()
  })

  it('hasVerified', async function () {
    const hash = util.sha3(Buffer.from(guest.replace(/^0x/, ''), 'hex'))
    let signature = util.ecsign(hash, ownerKey)
    let vTicket = '0x' + Buffer.from([signature.v]).toString('hex')
    let rTicket = '0x' + signature.r.toString('hex')
    let sTicket = '0x' + signature.s.toString('hex')

    assert(vTicket === '0x1b')
    assert(rTicket === '0x6028ddcb76a4dd56032ea59c36c6dfc515e552daff232446cc48110144ff137b')
    assert(sTicket === '0x296b8f1c56161ae528964858e7bcdee3948dfe5c4128625afee164b70bc2d229')

    const verified = await contract.hasVerified(guest, vTicket, rTicket, sTicket)
    assert(verified)


  })

  it('transferInspector', async function () {
    await contract.transferInspector(inspector)
    const hash = util.sha3(Buffer.from(guest.replace(/^0x/, ''), 'hex'))
    let signature = util.ecsign(hash, inspectorKey)
    let vTicket = '0x' + Buffer.from([signature.v]).toString('hex')
    let rTicket = '0x' + signature.r.toString('hex')
    let sTicket = '0x' + signature.s.toString('hex')

    assert(vTicket === '0x1b')
    assert(rTicket === '0x56061d530116d17e4430814a4f05bc36333cfcc12afbd3838ea764717e0d885a')
    assert(sTicket === '0x3a403a5561e6ea57918468f971b630062fc788542371d97af3694b1bcbe9a664')

    const verified = await contract.hasVerified(guest, vTicket, rTicket, sTicket)
    assert(verified)



  })

})

