import { HardhatRuntimeEnvironment } from "hardhat/types";
import type { DeployFunction } from "hardhat-deploy/dist/types";

const deployFreelanceEscrow: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  if (!deployer) {
    throw new Error("Deployer account not found!");
  }

  console.log("Deploying FreelanceEscrow contract from:", deployer);

  const escrow = await deploy("FreelanceEscrow", {
    from: deployer,
    args: [], // Pass constructor arguments if needed
    log: true,
  });

  console.log("Escrow contract deployed at:", escrow.address);
};

export default deployFreelanceEscrow;

deployFreelanceEscrow.tags = ["FreelanceEscrow"];
