module.exports = {
  networks: {
    development: {
      host: "172.23.240.1",
      port: 7545,
      network_id: "5777", // Match any network id
    }
  },
  compilers: {
    solc: {
      version: "0.8.12", // A version or constraint - Ex. "^0.5.0"
      settings: {
        optimizer: {
          enabled: true, // Default: false
          runs: 200      // Default: 200
        },
      }
    }
  }
};
