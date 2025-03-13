// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {EventLogger} from "../src/EventLogger.sol";

contract EventLoggerTest is Test {
    EventLogger private eventLogger;

    address private alice = address(0x1);
    address private bob = address(0x2);

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    function setUp() public {
        eventLogger = new EventLogger();
    }

    function testdeposit() public {
        vm.prank(alice);
        vm.deal(alice, 1 ether);

        // Expect the Deposited event to be emitted
        vm.expectEmit(true, true, true, true);
        emit Deposited(alice, 1 ether);

        // Perform the deposit
        eventLogger.deposit{value: 1 ether}();

        // Check Alice's balance
        uint256 aliceBalance = eventLogger.getBalance(alice);
        assertEq(aliceBalance, 1 ether);
    }

    function testDepositZeroETH() public {
        vm.prank(alice);
        vm.expectRevert("Deposit amount must be greater than zero");
        eventLogger.deposit{value: 0}();
    }

    function testwithdraw() public {
        // Simulate Alice depositing 1 ETH
        vm.prank(alice);
        vm.deal(alice, 1 ether);
        eventLogger.deposit{value: 1 ether}();

        // Expect the Withdrawn event to be emitted
        vm.expectEmit(true, true, true, true);
        emit Withdrawn(alice, 0.5 ether);

        // Perform the withdrawal
        vm.prank(alice);
        eventLogger.withdraw(0.5 ether);

        // Check Alice's balance after withdrawal
        uint256 aliceBalance = eventLogger.getBalance(alice);
        assertEq(aliceBalance, 0.5 ether);

        // Expect the Withdrawn event to be emitted again
        vm.expectEmit(true, true, true, true);
        emit Withdrawn(alice, 0.5 ether);

        // Perform the second withdrawal
        vm.prank(alice);
        eventLogger.withdraw(0.5 ether);

        // Check Alice's balance after the second withdrawal
        aliceBalance = eventLogger.getBalance(alice);
        assertEq(aliceBalance, 0);
    }

    function testWithdrawInsufficientBalance() public {
        vm.prank(alice);
        vm.deal(alice, 1 ether);

        eventLogger.deposit{value: 1 ether}();

        vm.prank(alice);
        vm.expectRevert("Insufficient balance");
        eventLogger.withdraw(2 ether);
    }

    function testGetBalance() public {
        vm.prank(alice);
        vm.deal(alice, 1 ether);
        eventLogger.deposit{value: 1 ether}();
        uint256 aliceBalance = eventLogger.getBalance(alice);
        assertEq(aliceBalance, 1 ether);

        uint256 bobBalance = eventLogger.getBalance(bob);
        assertEq(bobBalance, 0);
    }
}
