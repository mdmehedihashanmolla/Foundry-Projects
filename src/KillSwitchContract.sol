// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract KillSwitchContract {
    address public owner;
    bool public isDisabled;

    constructor() {
        owner = msg.sender;
        isDisabled = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    modifier contractActive() {
        require(!isDisabled, "Contract is disabled");
        _;
    }

    receive() external payable {}

    function disableContract(address payable _receipient) public onlyOwner {
        isDisabled = true;
        _receipient.transfer(address(this).balance);
    }

    function someFunction() public contractActive {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
