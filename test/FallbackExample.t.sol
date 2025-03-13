// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {FallbackExample} from "../src/FallbackExample.sol";

contract FallbackExampleTest is Test {
    FallbackExample fallbackExample;

    address alice = address(0x1);
    address bob = address(0x2);

    event Received(address indexed sender, uint256 amount);

    function setUp() public {
        fallbackExample = new FallbackExample();
    }

    function testReceiveEther() public {
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        (bool success,) = address(fallbackExample).call{value: 1 ether}("");
        require(success, "Failed to send Ether");

        uint256 balance = fallbackExample.getBalance(alice);
        assertEq(balance, 1 ether, "Alice's balance should be 1 ether");
    }

    function testFallbackFunction() public {
        vm.deal(bob, 1 ether);
        vm.prank(bob);
        (bool success,) = address(fallbackExample).call{value: 1 ether}("some data");
        require(success, "Failed to send Ether with data");

        uint256 balance = fallbackExample.getBalance(bob);
        assertEq(balance, 1 ether, "Bob's balance should be 1 ether");
    }

    function testGetBalance() public {
        vm.deal(alice, 1 ether);
        vm.deal(bob, 1 ether);

        vm.prank(alice);
        (bool successAlice,) = address(fallbackExample).call{value: 1 ether}("some data");
        require(successAlice, "Failed to send Ether to Alice");

        vm.prank(bob);
        (bool successBob,) = address(fallbackExample).call{value: 1 ether}("some data");
        require(successBob, "Failed to send Ether to Bob");

        uint256 aliceBalance = fallbackExample.getBalance(alice);
        uint256 bobBalance = fallbackExample.getBalance(bob);

        assertEq(aliceBalance, 1 ether, "Alice's balance should be 1 ether");
        assertEq(bobBalance, 1 ether, "Bob's balance should be 1 ether");
    }
}
