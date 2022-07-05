import { expect } from "chai";
import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

describe("ownership", () => {
  let signers: SignerWithAddress[];
  let owner: string;
  let ownerAcc: SignerWithAddress;
  let contract: any;

  before(async () => {
    signers = await ethers.getSigners();
    ownerAcc = signers[0];
    owner = await ownerAcc.getAddress();
  });

  beforeEach(async () => {
    const Artifact = await ethers.getContractFactory("Contract");
    contract = (await Artifact.deploy()) as any;
    await contract.deployed();
  });

  it("only owner can transfer ownership", async () => {
    const newOwner = signers[1].address;
    const from = signers[2].address;
    const tx = contract.transferOwnership(newOwner, { from });
    await expect(tx).to.be.reverted;
  });

  it("should be able to transfer ownership", async () => {
    let contractOwner: string;
    contractOwner = await contract.owner();
    expect(contractOwner).to.equal(owner);
    const newOwner = signers[1].address;
    const tx = await contract.transferOwnership(newOwner);
    await tx.wait();
    contractOwner = await contract.owner();
    expect(contractOwner).to.equal(newOwner);
  });
});
