// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BuildingNFT - minimal ERC721-like NFT
contract BuildingNFT {
    string public name = "BuildingNFT";
    string public symbol = "BLDG";

    mapping(uint256 => address) private _ownerOf;
    mapping(address => uint256) private _balanceOf;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    mapping(uint256 => string) private _tokenURI;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function mint(address to, uint256 tokenId, string calldata uri) external {
        require(to != address(0), "zero");
        require(_ownerOf[tokenId] == address(0), "exists");
        _ownerOf[tokenId] = to;
        _balanceOf[to] += 1;
        _tokenURI[tokenId] = uri;
        emit Transfer(address(0), to, tokenId);
    }

    function burn(uint256 tokenId) external {
        address owner = _ownerOf[tokenId];
        require(owner != address(0), "no token");
        require(msg.sender == owner || _tokenApprovals[tokenId] == msg.sender || _operatorApprovals[owner][msg.sender], "not authorized");
        _approve(address(0), tokenId);
        _balanceOf[owner] -= 1;
        delete _ownerOf[tokenId];
        delete _tokenURI[tokenId];
        emit Transfer(owner, address(0), tokenId);
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address o = _ownerOf[tokenId];
        require(o != address(0), "no owner");
        return o;
    }

    function balanceOf(address owner_) public view returns (uint256) {
        require(owner_ != address(0), "zero");
        return _balanceOf[owner_];
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return _tokenURI[tokenId];
    }

    function approve(address to, uint256 tokenId) external {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner || _operatorApprovals[owner][msg.sender], "not approved");
        _approve(to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) external {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function getApproved(uint256 tokenId) external view returns (address) {
        return _tokenApprovals[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(owner == from, "not owner");
        require(to != address(0), "zero");
        require(msg.sender == owner || _tokenApprovals[tokenId] == msg.sender || _operatorApprovals[owner][msg.sender], "not allowed");
        _approve(address(0), tokenId);
        _balanceOf[from] -= 1;
        _balanceOf[to] += 1;
        _ownerOf[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
}
