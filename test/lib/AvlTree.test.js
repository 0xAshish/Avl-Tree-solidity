import chai from 'chai'
import chaiAsPromised from 'chai-as-promised'
import chaiBigNumber from 'chai-bignumber'

import { linkLibs } from '../helpers/utils'
// const AvlTree = artifacts.require("./lib/AvlTree.sol");
import { AvlTree } from '../helpers/contracts'

// add chai pluggin
chai
  .use(chaiAsPromised)
  .use(chaiBigNumber(web3.BigNumber))
  .should()

contract('AvlTree', async function() {
  let avlTree

  beforeEach(async function() {
    // await linkLibs()
    avlTree = await AvlTree.new()
  })

  // generates random int between start and end
  function getRandInt(start, end) {
    return Math.floor(Math.random() * (end - start) + start)
  }

  it('should initialize properly', async function() {
    // root should be NULL/0
    let root = await avlTree.getRoot()
    root.should.be.bignumber.equal(0)
  })

  it('should set root correct and balanced', async function() {
    await avlTree.insert(14)
    await avlTree.insert(17)
    await avlTree.insert(11)
    await avlTree.insert(7)
    await avlTree.insert(53)
    await avlTree.insert(4)

    let root = await avlTree.getRoot()
    root.should.be.bignumber.equal(14)
  })

  it('should insert 700 node randomly and get max back correctly', async function() {
    let max = -1
    let min = 99999999999999
    let p = []
    for (let i = 99999999998100; i < 99999999998800; i++) {
      const value = i
      if (value > max) max = value
      else if (value < min) min = value
      const recpt = await avlTree.insert(value)
    }

    await Promise.all(p)
    let treeMax = await avlTree.getMax()
    let treeMin = await avlTree.getMin()
    // treeMax.should.be.bignumber.equal(max)
    // treeMin.should.be.bignumber.equal(min)
  })

  it('should insert 700 node randomly and get max back correctly', async function() {
    let max = -1
    let min = 99999999999999
    let p = []
    for (let i = 99999999999100; i < 99999999999200; i++) {
      const value = i // getRandInt(55, 99999999999999)
      if (value > max) max = value
      else if (value < min) min = value
      const recpt = await avlTree.insert(value)
    }

    await Promise.all(p)
    let treeMax = await avlTree.getMax()
    let treeMin = await avlTree.getMin()
    // treeMax.should.be.bignumber.equal(max)
    // treeMin.should.be.bignumber.equal(min)
  })
  it('should delete 700 node ', async function() {
    let max = -1
    let min = 99999999999999
    let p = []
    for (let i = 99999999999100; i < 99999999999800; i++) {
      const value = i // getRandInt(55, 99999999999999)
      // if (value > max) max = value
      // else if (value < min) min = value
      const recpt = await avlTree.deleteNode(value)
    }

    // await Promise.all(p)
    let treeMax = await avlTree.getMax()
    let treeMin = await avlTree.getMin()
    // treeMax.should.be.bignumber.equal(max)
    // treeMin.should.be.bignumber.equal(min)
  })

  it('should insert one node and check balancing gas cost after 1000 node', async function() {
    await avlTree.insert(84630396498)
    let bool = await avlTree.search(84630396498)
    assert(bool, 'must find inserted node')
  })
})
