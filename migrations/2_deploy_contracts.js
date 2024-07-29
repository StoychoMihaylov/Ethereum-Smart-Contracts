const coffeeSupplyChainContract = artifacts.require("SupplyChainManagmentSmartContract.sol");

module.exports = function (deployer) {
  const version = 1; // Increment before deploy
  deployer.deploy(coffeeSupplyChainContract, version);
};