import { ethers, run } from "hardhat"

const axo = "0xC5C24B76de65808eD1c17E411c6C5cfC78FA1A98"
const wmatic = "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270"
const factory = "0x19b5e69b40b43438e69e393A6a808b218d20163B"
const xlt = "0x19072f56Af0a815d62B1B4651eECC82200eb922B"
const usdc = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"
const dai = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063"

async function main() {
    const Summoning = await ethers.getContractFactory("Summoning");
    const summoning = await Summoning.deploy(factory, xlt, axo, wmatic, usdc, dai);
    await summoning.deployed()
    console.log("Summoning deployed to:", summoning.address);

    await run("verify:verify", {
      address: summoning.address,
      constructorArguments: [factory, xlt, axo, wmatic, usdc, dai],
  })
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
