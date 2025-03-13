// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {PersonRegistry} from "../src/PersonRegistry.sol";

contract PersonRegistryTest is Test {
    PersonRegistry private personRegistry;

    address private alice = address(0x1);
    address private bob = address(0x2);

    event PersonAdded(string name, uint age, address wallet);

    function setUp() public {
        personRegistry = new PersonRegistry();
    }

    function testAddPerson() public {
        vm.prank(alice);

        personRegistry.addPerson("Alice", 25);

        (string memory name, uint age, address wallet) = personRegistry
            .getPerson(0);
        assertEq(name, "Alice");
        assertEq(age, 25);
        assertEq(wallet, alice);

        assertEq(personRegistry.getTotalPersons(), 1);
    }

    function testGetPersonOutofBounds() public {
        vm.expectRevert("Index out of bound");

        personRegistry.getPerson(0);
    }
    function testAddMultiplePerson() public {
        vm.prank(alice);
        personRegistry.addPerson("Alice", 25);

        vm.prank(bob);
        personRegistry.addPerson("Bob", 30);
        assertEq(personRegistry.getTotalPersons(), 2);

        (
            string memory aliceName,
            uint aliceAge,
            address aliceWallet
        ) = personRegistry.getPerson(0);

        assertEq(aliceName, "Alice");
        assertEq(aliceAge, 25);
        assertEq(aliceWallet, alice);

        (string memory bobName, uint bobAge, address bobWallet) = personRegistry
            .getPerson(1);

        assertEq(bobName, "Bob");
        assertEq(bobAge, 30);
        assertEq(bobWallet, bob);
    }

    function testPersonAddedEvent() public {
        vm.expectEmit(true, true, true, true);
        emit PersonAdded("Alice", 25, alice);

        // Add Alice
        vm.prank(alice);
        personRegistry.addPerson("Alice", 25);
    }
}
