// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TucuToken {
    using SafeMath for uint256;

    string public name = "Tucu Token";
    string public symbol = "TUC";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => bool) public hasClaimedReward;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);
    event RewardClaimed(address indexed recipient, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function mint(uint256 amount) external onlyOwner {
        totalSupply = totalSupply.add(amount);
        balanceOf[owner] = balanceOf[owner].add(amount);

        emit Transfer(address(0), owner, amount);
        emit Mint(owner, amount);
    }

    function claimReward() external {
        require(!hasClaimedReward[msg.sender], "Reward already claimed");

        balanceOf[msg.sender] = balanceOf[msg.sender].add(5);
        totalSupply = totalSupply.add(5);
        hasClaimedReward[msg.sender] = true;

        emit Transfer(address(0), msg.sender, 5);
        emit RewardClaimed(msg.sender, 5);
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
    }

    function withdraw(uint256 amount) external onlyOwner {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(amount <= address(this).balance, "Insufficient contract balance");

        payable(owner).transfer(amount);
    }

}
