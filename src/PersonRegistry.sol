// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract PersonRegistry {
    struct Person {
        string name;
        uint256 age;
        address wallet;
    }

    Person[] private persons;

    event PersonAdded(string name, uint256 age, address wallet);

    function addPerson(string memory _name, uint256 _age) public {
        persons.push(Person(_name, _age, msg.sender));
        emit PersonAdded(_name, _age, msg.sender);
    }

    function getPerson(uint256 index) public view returns (string memory, uint256, address) {
        require(index < persons.length, "Index out of bound");
        Person memory p = persons[index];
        return (p.name, p.age, p.wallet);
    }

    function getTotalPersons() public view returns (uint256) {
        return persons.length;
    }
}
