// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract BasicStorage {
    uint256 private storedNumber;

    event NumberStored(uint256 newValue);

    function store(uint256 _num) public {
        storedNumber = _num;
        emit NumberStored(_num);
    }

    function retrieve() public view returns (uint256) {
        return storedNumber;
    }
}
