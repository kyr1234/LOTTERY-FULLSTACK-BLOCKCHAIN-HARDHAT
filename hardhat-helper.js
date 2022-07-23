const { ethers } = require('ethers')

const networkConfig = {
  default: {
    name: 'hardhat',
    keepersUpdateInterval: '30',
    entranceFee: ethers.utils.parseEther('0.01'),
  },
  31337: {
    name: 'localhost',
    entranceFee: ethers.utils.parseEther('0.01'),

    gasLane:
      '0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc', // 30 gwei
    subscriptionId: '0',
    Interval: '30',

    callbackGasLimit: '500000', // 500,000 gas
  },
  4: {
    name: 'rinkeby',
    entranceFee: ethers.utils.parseEther('0.01'),
    gasLane:
      '0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc', // 30 gwei
    subscriptionId: '8949',
    Interval: '30',

    callbackGasLimit: '500000', // 500,000 gas
    vrfCoordinatorV2: '0x6168499c0cFfCaCD319c818142124B7A15E857ab',
  },
}

const developmentChains = ['hardhat', 'localhost']
const VERIFICATION_BLOCK_CONFIRMATIONS=6
module.exports = {
  networkConfig,
  developmentChains,
  VERIFICATION_BLOCK_CONFIRMATIONS
}
