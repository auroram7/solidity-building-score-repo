// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract BuildingAuction {
    address public seller;
    IERC721 public nft;
    uint256 public tokenId;
    uint256 public highestBid;
    address public highestBidder;
    bool public ended;

    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);

    constructor(address nftAddr, uint256 id) {
        seller = msg.sender;
        nft = IERC721(nftAddr);
        tokenId = id;
    }

    function bid() external payable {
        require(!ended, "ended");
        require(msg.value > highestBid, "bid too low");
        if (highestBid > 0) {
            payable(highestBidder).transfer(highestBid);
        }
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit BidPlaced(msg.sender, msg.value);
    }

    function end() external {
        require(msg.sender == seller, "only seller");
        require(!ended, "already ended");
        ended = true;
        nft.transferFrom(seller, highestBidder, tokenId);
        payable(seller).transfer(highestBid);
        emit AuctionEnded(highestBidder, highestBid);
    }
}
