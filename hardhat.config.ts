import * as dotenv from "dotenv";

import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "hardhat-etherscan-abi";

require("solidity-coverage");

import { task } from "hardhat/config";

dotenv.config();

task("accounts", "lists accounts", async (_, { ethers }) => {
  const signers = await ethers.getSigners();
  for (let signer of signers) {
    console.log(signer.address);
  }
});

const accounts = [process.env.PRIVATE_KEY || ""];

const infuraKey = process.env.INFURA_KEY;

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.13",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  typechain: {
    outDir: "./typechain",
    target: "ethers-v5",
  },
  networks: {
    rinkeby: {
      accounts,
      url: `https://rinkeby.infura.io/v3/${infuraKey}`,
      chainId: 4,
    },
    mainnet: {
      accounts,
      url: `https://mainnet.infura.io/v3/${infuraKey}`,
      chainId: 1,
    },
    hardhat: {
      forking: {
        url: `https://mainnet.infura.io/v3/${infuraKey}`,
      },
      chainId: 1,
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
    src: "./contracts",
  },
  etherscan: { apiKey: process.env.ETHERSCAN_KEY },
  mocha: {
    timeout: 10000000,
  },
};

export default config;
