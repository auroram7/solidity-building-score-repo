// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BuildingScore - simple, single-file on-chain score tracker
/// @notice Stores and manages a "building score" per buildingId.
contract BuildingScore {
    address public owner;
    mapping(uint256 => uint256) private _score;
    mapping(address => bool) public admins;

    event ScoreIncreased(uint256 indexed buildingId, uint256 oldScore, uint256 newScore, address indexed by);
    event ScoreSet(uint256 indexed buildingId, uint256 oldScore, uint256 newScore, address indexed by);
    event AdminUpdated(address indexed admin, bool enabled);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    modifier onlyAdminOrOwner() {
        require(msg.sender == owner || admins[msg.sender], "only admin or owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        admins[msg.sender] = true;
    }

    function setAdmin(address a, bool enabled) external onlyOwner {
        admins[a] = enabled;
        emit AdminUpdated(a, enabled);
    }

    function scoreOf(uint256 buildingId) external view returns (uint256) {
        return _score[buildingId];
    }

    function increaseScore(uint256 buildingId, uint256 delta) external onlyAdminOrOwner {
        require(delta > 0, "delta>0");
        uint256 old = _score[buildingId];
        uint256 nw = old + delta;
        _score[buildingId] = nw;
        emit ScoreIncreased(buildingId, old, nw, msg.sender);
    }

    function setScore(uint256 buildingId, uint256 newScore) external onlyAdminOrOwner {
        uint256 old = _score[buildingId];
        _score[buildingId] = newScore;
        emit ScoreSet(buildingId, old, newScore, msg.sender);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "zero");
        owner = newOwner;
    }
}
