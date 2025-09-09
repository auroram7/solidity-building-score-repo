// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BuildingScoreMarket - buy score boosts with ETH
contract BuildingScoreMarket {
    address public owner;
    uint256 public basePriceWei = 0.01 ether;
    uint256 public soldPoints;

    event Bought(address indexed buyer, uint256 buildingId, uint256 points, uint256 paid);
    event BasePriceUpdated(uint256 oldPrice, uint256 newPrice);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function buyPoints(address buildingScoreAddress, uint256 buildingId, uint256 points) external payable {
        require(points > 0, "points>0");
        uint256 multiplierNumerator = 10000 + soldPoints;
        uint256 multiplierDenominator = 10000;
        uint256 cost = (basePriceWei * points);
        cost = (cost * multiplierNumerator) / multiplierDenominator;
        require(msg.value >= cost, "insufficient");

        (bool ok, ) = buildingScoreAddress.call(
            abi.encodeWithSignature("increaseScore(uint256,uint256)", buildingId, points)
        );
        require(ok, "increase failed");

        soldPoints += points;
        if (msg.value > cost) {
            payable(msg.sender).transfer(msg.value - cost);
        }

        emit Bought(msg.sender, buildingId, points, cost);
    }

    function withdraw(address payable to) external onlyOwner {
        to.transfer(address(this).balance);
    }

    function setBasePriceWei(uint256 newPrice) external onlyOwner {
        uint256 old = basePriceWei;
        basePriceWei = newPrice;
        emit BasePriceUpdated(old, newPrice);
    }
}
