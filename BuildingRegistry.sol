// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BuildingRegistry {
    struct Building {
        string name;
        string location;
        uint256 createdAt;
        address owner;
    }

    Building[] public buildings;

    event Registered(uint256 indexed id, string name, string location, address indexed owner);

    function register(string calldata name, string calldata location) external {
        buildings.push(Building(name, location, block.timestamp, msg.sender));
        emit Registered(buildings.length - 1, name, location, msg.sender);
    }

    function getBuilding(uint256 id) external view returns (string memory, string memory, uint256, address) {
        require(id < buildings.length, "bad id");
        Building storage b = buildings[id];
        return (b.name, b.location, b.createdAt, b.owner);
    }

    function totalBuildings() external view returns (uint256) {
        return buildings.length;
    }
}
