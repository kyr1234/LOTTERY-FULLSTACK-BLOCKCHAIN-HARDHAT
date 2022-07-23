const { network } = require('hardhat')
const { developmentChains } = require('../hardhat-helper')

const BASE_FEE = ethers.utils.parseEther('0.25')
const GAS_PRICE_LINK = 1e9

module.exports = async function ({ getNamedAccounts, deployments }) {
  const { log, deploy } = deployments
  const { deployer } = await getNamedAccounts()
  const args = [BASE_FEE, GAS_PRICE_LINK]
  if (developmentChains.includes(network.name)) {
    log('LOCAL NETOWORK  DETECTED ! DEPLOYING MOCKS ')
    const deployMockV3Coordinator = await deploy('VRFCoordinatorV2Mock', {
      contract: 'VRFCoordinatorV2Mock',
      from: deployer,
      log: true,
      args: args,
    })

    log('THE COORDINATOR CONTRACT DEPLOYED')
  }
}

module.exports.tags = ['all', 'mocks']
