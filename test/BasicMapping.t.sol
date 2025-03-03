// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {BasicMapping} from "../src/BasicMapping.sol";

contract BasicMappingTest is Test {
    BasicMapping private basicMapping;

    address private alice = address(0x123);
    address private bob = address(0x456);

    event BalanceUpdated(address indexed user, uint256 newBalance);

    function setUp() public {
        basicMapping = new BasicMapping();
    }

    function testInitialBalance() public view {
        uint256 balance = basicMapping.getBalance(alice);
        assertEq(balance, 0, "Initial balance should be 0");
    }

    function testSetBalance() public {
        uint256 amount = 100;

        vm.expectEmit(true, true, true, true);
        emit BalanceUpdated(alice, amount);

        vm.prank(alice);
        basicMapping.setBalance(amount);

        uint256 balance = basicMapping.getBalance(alice);
        assertEq(balance, amount, "Balance should be updated to the correct4 amount");
    }

    function testSetBalanceFromDifferentUsers() public {
        uint256 aliceAmount = 100;
        uint256 bobAmount = 200;

        vm.prank(alice);
        basicMapping.setBalance(aliceAmount);

        uint256 aliceBalance = basicMapping.getBalance(alice);
        assertEq(aliceBalance, aliceAmount, "Alice's balance should remain unchanged");
        vm.prank(bob);
        basicMapping.setBalance(bobAmount);

        uint256 bobBalance = basicMapping.getBalance(bob);
        assertEq(bobBalance, bobAmount, "Bob's balance should be updated coorectly");
    }

    function testUpdateBalance() public {
        uint256 initialAmount = 100;
        uint256 updateAmount = 200;

        vm.prank(alice);
        basicMapping.setBalance(initialAmount);

        uint256 balance = basicMapping.getBalance(alice);
        assertEq(balance, initialAmount, "Initial balance should be set correctly");

        vm.prank(alice);
        basicMapping.setBalance(updateAmount);

        balance = basicMapping.getBalance(alice);
        assertEq(balance, updateAmount, "Balance Should be updated to the new amount");
    }
}
