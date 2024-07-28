const coffeeSupplyChainContract = artifacts.require("SupplyChainManagmentSmartContract.sol");

module.exports = function (deployer) {
  deployer.deploy(coffeeSupplyChainContract);
};