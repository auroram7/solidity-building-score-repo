// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BuildingBadge {
    mapping(address => uint256) public badges;
    event BadgeEarned(address indexed user, uint256 total);

    function earnBadge() external {
        badges[msg.sender] += 1;
        emit BadgeEarned(msg.sender, badges[msg.sender]);
    }
}
