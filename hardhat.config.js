require('@nomiclabs/hardhat-waffle')
require('@nomiclabs/hardhat-etherscan')
require('hardhat-deploy')
require('solidity-coverage')
require('hardhat-gas-reporter')
require('hardhat-contract-sizer')
require('dotenv').config()

/** @type import('hardhat/config').HardhatUserConfig */

const RINKEBY_RPC_URL = process.env.RINKEBY_RPC_URL
const ETHERSCAN_API_KEY = process.env.EHTERSCAN_API_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY
const COINMARKET_API_KEY = process.env.COINMARKET_API_KEY

module.exports = {
  defaultNetwork: 'hardhat',
  networks: {
    hardhat: {
      chainId: 31337,
    },
    rinkeby: {
      chainId: 4,
      url: RINKEBY_RPC_URL,
      accounts: [PRIVATE_KEY],
      waitConfirmations: 6,
    },
  },
  gasReporter: {
    enabled: false,
    curreny: 'USD',
    noColors: true,
    coinmarketcap: process.env.COINMARKET_API_KEY,
  },
  etherscan: {
    // yarn hardhat verify --network <NETWORK> <CONTRACT_ADDRESS> <CONSTRUCTOR_PARAMETERS>
    apiKey: {
      rinkeby: ETHERSCAN_API_KEY,
    },
  },
  solidity: '0.8.9',
  namedAccounts: {
    deployer: {
      default: 0,
    },
    player: {
      default: 1,
    },
  },
  mocha: {
    timeout: 50000,
  },
}
