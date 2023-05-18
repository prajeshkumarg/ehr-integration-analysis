const ElectronicHealthRecord = artifacts.require("ElectronicHealthRecord");
const HealthCare = artifacts.require("HealthCare");

module.exports = function(deployer) {
  deployer.deploy(ElectronicHealthRecord);
  deployer.deploy(HealthCare);
  deployer.link(ElectronicHealthRecord, HealthCare);
};
