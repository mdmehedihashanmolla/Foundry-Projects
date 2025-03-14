// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract TimeLockContract {
    address public owner;
    uint256 public unlockTime;

    event FundsDeposited(address indexed sender, uint256 amount, uint256 unlockTime);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    constructor(uint256 _lockDuration) {
        owner = msg.sender;
        unlockTime = block.timestamp + _lockDuration; // Lock period in seconds
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier isUnlocked() {
        require(block.timestamp >= unlockTime, "Funds are locked");
        _;
    }

    receive() external payable {
        emit FundsDeposited(msg.sender, msg.value, unlockTime);
    }

    function withdrawFunds() public onlyOwner isUnlocked {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available");
        payable(owner).transfer(balance);
        emit FundsWithdrawn(owner, balance);
    }

    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= unlockTime) {
            return 0;
        }
        return unlockTime - block.timestamp;
    }
}
