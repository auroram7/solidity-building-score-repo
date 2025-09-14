// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BuildingDAO {
    struct Proposal {
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    Proposal[] public proposals;
    mapping(address => bool) public members;
    mapping(uint256 => mapping(address => bool)) public voted;

    event ProposalCreated(uint256 id, string description);
    event Voted(uint256 id, bool support);
    event Executed(uint256 id, bool passed);

    modifier onlyMember() {
        require(members[msg.sender], "not member");
        _;
    }

    constructor() {
        members[msg.sender] = true;
    }

    function addMember(address user) external onlyMember {
        members[user] = true;
    }

    function createProposal(string calldata desc) external onlyMember {
        proposals.push(Proposal(desc, 0, 0, false));
        emit ProposalCreated(proposals.length - 1, desc);
    }

    function vote(uint256 id, bool support) external onlyMember {
        require(id < proposals.length, "bad id");
        require(!voted[id][msg.sender], "already voted");
        voted[id][msg.sender] = true;
        if (support) proposals[id].votesFor++;
        else proposals[id].votesAgainst++;
        emit Voted(id, support);
    }

    function execute(uint256 id) external onlyMember {
        Proposal storage p = proposals[id];
        require(!p.executed, "already executed");
        p.executed = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit Executed(id, passed);
    }
}
