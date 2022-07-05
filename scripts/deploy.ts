import { ethers } from "hardhat";

export const deploy = async (contractName: string) => {
  const [deployer] = await ethers.getSigners();
  const Artifact = await ethers.getContractFactory(contractName);
  const contract = await Artifact.deploy();
  await contract.deployed();
  console.log("Network:", ethers.provider.network.name);
  console.log("StonedCookies address:", contract.address);
  console.log("Deployer:", deployer.address);
};

async function main() {
  deploy("#");
}

main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
