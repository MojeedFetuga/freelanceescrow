import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-deploy";
import * as dotenv from "dotenv";

dotenv.config();


const { PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: process.env.ALCHEMY_API_URL, // Your Sepolia network URL
      accounts: [`0x${PRIVATE_KEY}`], // Your private key
    },
  },
  namedAccounts: {
    deployer: 0,
  },
};

export default config;
