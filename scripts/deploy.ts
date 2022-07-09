import { ethers, run } from "hardhat"

async function main() {

    const Xolotl = await ethers.getContractFactory("Xolotl");
    const xolotl = await Xolotl.deploy('0xC5C24B76de65808eD1c17E411c6C5cfC78FA1A98');
    console.log("Xolotl token deployed to:", xolotl.address);
    await run("verify:verify", {
      address: xolotl.address,
      constructorArguments: ['0xC5C24B76de65808eD1c17E411c6C5cfC78FA1A98'],
  },
  )
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
