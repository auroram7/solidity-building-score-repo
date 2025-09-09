Solidity Building Score Repo 🏗️✨

This repository contains three single-file Solidity smart contracts that let you:

Track “building scores” on-chain

Mint NFTs that represent buildings

Sell score boosts in exchange for ETH

All contracts are self-contained (no imports, no external dependencies), so they are easy to verify on Etherscan/Blockscout without flattening. Just copy and paste the file you deployed.

📂 Repository Structure
contracts/
├── BuildingScore.sol
├── BuildingNFT.sol
└── BuildingScoreMarket.sol


Each contract is a separate .sol file. You can use them individually or together.

📝 Contract Overviews
1. BuildingScore.sol

Manages an on-chain score per buildingId.

Owner and admins can:

Increase scores

Set scores directly

Add/remove admins

Events make score changes traceable.

👉 Example usage:

// increase score of building #1 by +10
buildingScore.increaseScore(1, 10);

2. BuildingNFT.sol

A minimal NFT implementation (ERC-721 style, but no imports).

Lets you mint NFTs for buildings with a metadata URI.

Includes transfers, approvals, and burning.

Great for representing real-world or game buildings.

👉 Example usage:

// mint building NFT to user
buildingNFT.mint(msg.sender, 1001, "ipfs://QmHashOfYourMetadata");

3. BuildingScoreMarket.sol

A marketplace contract where users can buy building score points with ETH.

Dynamic pricing:
cost = basePriceWei * points * (1 + soldPoints/10000)

ETH is stored in the contract until the owner withdraws.

Integrates with BuildingScore via a function call.

👉 Example usage:

// buy +5 points for building #1
buildingScoreMarket.buyPoints{value: 0.05 ether}(scoreAddress, 1, 5);

🚀 How to Use with Remix

Open Remix IDE → https://remix.ethereum.org

Create a new workspace → Add a contracts/ folder.

Copy the .sol files from this repo into Remix.

Compile each file with compiler version 0.8.20.

Deploy:

BuildingScore.sol first (this will give you a score registry).

Optionally deploy BuildingNFT.sol if you want NFTs.

Deploy BuildingScoreMarket.sol and pass the BuildingScore contract address when buying points.

🔍 How to Verify on Etherscan

Since each contract is a single file:

Go to Etherscan → Verify & Publish.

Select Solidity version 0.8.20.

Paste the entire contract code from this repo.

Done ✅ (no need to flatten).

⚡ Example Flow

Deploy BuildingScore.

Deploy BuildingScoreMarket.

As the owner of BuildingScore, call setAdmin(marketAddress, true) → this allows the market contract to increase scores.

A user calls buyPoints(scoreAddress, buildingId, points) and pays ETH.

The market contract forwards the call to BuildingScore.increaseScore.

The building’s score is updated, and events are logged.

Optional: Deploy BuildingNFT to mint a token for each buildingId.

💡 Features

No dependencies → single-file verification friendly.

Upgradeable admin system → owner can add/remove admins.

Events → all key actions are logged.

Dynamic pricing in the market → more points sold = higher price.

NFT representation for buildings → tradeable assets.

⚠️ Notes & Caveats

These contracts are educational / experimental. Do not use in production without audits.

No advanced access control (like OpenZeppelin’s Ownable) is included; instead, ownership is handled manually.

Market contract relies on a low-level call to BuildingScore → make sure you pass the correct contract address.

Gas optimizations are minimal for clarity.

🌐 Optional HTML Frontend

If you want to interact without Remix, you can build a simple index.html that connects with MetaMask and calls functions (e.g., increaseScore, buyPoints). Drop it into GitHub Pages for free hosting.

📜 License

MIT License. Free to use, modify, and share.
