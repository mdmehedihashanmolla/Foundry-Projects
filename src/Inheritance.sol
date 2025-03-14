// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Parent {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }

    function getName() public view returns (string memory) {
        return name;
    }
}

contract Child is Parent {
    uint256 public age;

    constructor(string memory _name, uint256 _age) Parent(_name) {
        age = _age;
    }

    function getAge() public view returns (uint256) {
        return age;
    }
}
