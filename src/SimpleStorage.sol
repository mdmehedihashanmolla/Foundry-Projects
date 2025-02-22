// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SimpleStorage {
    uint256 private storedValue;

    event ValueChanged(uint256 newValue);

    function setValue(uint256 _value) public {
        require(_value > 0, "Value must be greater than zero");
        storedValue = _value;
        emit ValueChanged(_value);
    }
    function getValue() public view returns (uint256) {
        return storedValue;
    }
}
