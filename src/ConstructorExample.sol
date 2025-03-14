// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract ConstructorExample {
    address public owner;
    string public contractName;

    constructor(string memory _name) {
        owner = msg.sender;
        contractName = _name;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getContractName() public view returns (string memory) {
        return contractName;
    }
}
