const RBBRegistry = artifacts.require("RBBRegistry");
const Notarizer = artifacts.require("Notarizer");
const BNDESPublicTenderNotarizer = artifacts.require("BNDESPublicTenderNotarizer");

module.exports = function(deployer) {
  deployer.deploy(RBBRegistry);
  deployer.link(RBBRegistry, Notarizer);
  deployer.deploy(Notarizer);
  deployer.link(RBBRegistry, BNDESPublicTenderNotarizer);
  deployer.deploy(BNDESPublicTenderNotarizer);

};
