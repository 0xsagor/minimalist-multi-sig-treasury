const { ethers } = require("hardhat");

async function main() {
  const [owner1, owner2, owner3] = await ethers.getSigners();
  const MultiSig = await ethers.getContractFactory("MultiSigWallet");
  const wallet = await MultiSig.deploy([owner1.address, owner2.address, owner3.address], 2);
  
  console.log("MultiSig deployed to:", wallet.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
