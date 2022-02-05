// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts";
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract erc20GreenGoose is IERC20 {
    string name;
    string symbol;
    uint256 totalSupply;
    uint8 decimals;
    address owner;
    uint256 tokenPrice;
    uint256 possiblePrice;
    bool governanceStatus;
    uint256 votes;
    uint256 voteDuration;
    uint256 votingEnds;
    uint256 governanceCount;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowance;
    mapping(address => mapping(uint256 => bool)) isVoted;

    constructor(string memory _name, string memory _symbol, uint256 _totalSupply, uint256 _voteDuration) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        decimals = _decimals;
        owner = msg.sender;
        voteDuration = _voteDuration;
    }

    function getName() public view returns (string memory){
        return name;
    }

    function getSymbol() public view returns (string memory) {
        return symbol;
    }

    function getSupply() public view returns (uint256) {
        return totalSupply;
    }

    function getDecimals() public view returns (uint256) {
        return decimals;
    }

    function getOwnerAddress() public view returns (address) {
        return owner;
    }

    function getBalance(address _address) public view returns (uint256) {
        return balances[_address];
    }

    function getAllowance(address tokenOwner, address spender) public view returns (uint256) {
        return allowance[tokenOwner][spender];
    }

    function votesAmount() public view returns (uint256) {
        return votes;
    }

    function getVoteDuration public view returns (uint256) {
        return voteDuration;
    }

    function transfer(address receiver, uint256 tokens) public returns (bool) {
        require(balances[msg.sender] >= tokens, "You're a fucking scammer!!!");
       
        balances[msg.sender] = balances[msg.sender] - tokens;
        balances[receiver] = balances[receiver] + tokens;
        
        return true;
    }

    function approve(address receiver, uint256 tokens) public returns (bool){
        allowance[msg.sender][receiver] = tokens;

        return true;
    }

    function increaseAllowance(address receiver, uint256 tokens) public returns (bool) {
        allowance[msg.sender][receiver] = allowance[msg.sender][receiver] + tokens;

        return true;
    }

    function decreaseAllowance(address receiver, uint256 tokens) public returns (bool) {
        allowance[msg.sender][receiver] = allowance[msg.sender][receiver] - tokens;

        return true;
    }

    function transferFrom(address from, address to, uint256 tokens) public returns (bool) {
        require(allowance[from][to] >= tokens, "This amount of tokens is not allowned.");
        
        allowance[from][to] = allowance[from][to] - tokens;
        balances[from] = balances[from] - tokens;
        balances[to] = balances[to] + tokens;

        return true;
    }

    function initGovernance(uint256 _possiblePrice) public returns (bool) {
        require(!governanceStatus, "There is another Governance is going on already.");
        require(balances[msg.sender[] > totalSupply / 20, "You need to have more than 5% of total token supply to init the Governance.");

        governanceStatus = true;
        possiblePrice = _possiblePrice; // price in wei
        votingEnds = block.timestamp + voteDuration;
        governanceCount ++;

        return true; 
    }

    function vote(bool _vote) public returns (bool) {
        require(governanceStatus, "Governance is not active.");
        require(!isVoted[msg.sender][governanceCount], "Sorry, you have already voted.");

        if (_vote) {
            votes += balances[msg.sender];
        }
        else {
            votes -= balances[msg.sender];
        }

        isVoted[msg.sender][governanceCount] = true;

        return true;
    }

    function stopGovernance() public return (bool) {
        require(block.timestamp >= votingEnds, "Governance can't be finished now.");

        if (votes > 0){
            tokenPrice = possiblePrice;
        }
        
        governanceStatus = false;
        votes = 0;

        return true;
    }
}