// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  const baseTokenURI = "ipfs://QmZbWNKJPAjxXuNFSEaksCJVd1M6DaKQViJBYPK2BdpDEP/";

  // Get owner/deployer's wallet address
  const [owner] = await ethers.getSigners();

  // Deploy the contract with the correct constructor arguments
  console.log("================================== SFSG ========================");
  const contractFactory = await ethers.getContractFactory("DecentraNFT");
  const NFTContract = await contractFactory.deploy(baseTokenURI);

  // Wait for this transaction to be mined
  await NFTContract.deployed();

  // Get contract address
  console.log("NFT Contract deployed to:", NFTContract.address);

  // Reserve NFTs
  let txn = await NFTContract.reserveNFTs();
  await txn.wait();
  console.log(await NFTContract.RESERVED_NFTS(), " NFTs have been reserved");

  // Mint 3 NFTs by sending 0.03 ether
  txn = await NFTContract.mintNFTs(3, { value: ethers.utils.parseEther("0.03") });
  await txn.wait();

  // Get all tokens IDs of the owner
  let tokens = await NFTContract.tokensOfOwner(owner.address);
  console.log("Owner has tokens: ", tokens);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exitCode = 0)
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
