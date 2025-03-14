// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {CircuitBreaker} from "../src/CircuitBreaker.sol";

contract CircuitBreakerTest is Test {
    CircuitBreaker public circuitBreaker;
    address public owner = address(0x1234); // Address to use as the owner
    address public user = address(0x5678); // Address to use as a user
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event Paused();
    event Unpaused();

    function setUp() public {
        // Deploy the CircuitBreaker contract
        vm.prank(owner); // Simulate the owner deploying the contract
        circuitBreaker = new CircuitBreaker();
    }

    function testOwner() public view{
        // Test that the owner is set correctly
        address contractOwner = circuitBreaker.owner();
        assertEq(contractOwner, owner);
    }

    function testPausedInitialState() public view {
        // Test that the contract is initially not paused
        bool paused = circuitBreaker.paused();
        assertEq(paused, false);
    }

    function testDeposit() public {
        // Test that the deposit function works and emits the Deposit event
        uint256 amount = 1 ether;

        vm.deal(user, amount); // Fund the user with Ether
        vm.prank(user); // Simulate the user calling the function

        // Check that the Deposit event is emitted
        vm.expectEmit(true, true, true, true);
        emit Deposit(user, amount);

        circuitBreaker.deposit{value: amount}();

        // Check the user's balance
        assertEq(circuitBreaker.getBalance(), amount);
        assertEq(circuitBreaker.balances(user), amount);
    }

    function testWithdraw() public {
        // Test that the withdraw function works and emits the Withdrawal event
        uint256 depositAmount = 1 ether;
        uint256 withdrawAmount = 0.5 ether;

        vm.deal(user, depositAmount); // Fund the user with Ether
        vm.prank(user); // Simulate the user depositing
        circuitBreaker.deposit{value: depositAmount}();

        // Check that the Withdrawal event is emitted
        vm.expectEmit(true, true, true, true);
        emit Withdrawal(user, withdrawAmount);

        vm.prank(user); // Simulate the user withdrawing
        circuitBreaker.withdraw(withdrawAmount);

        // Check the user's balance after withdrawal
        assertEq(circuitBreaker.getBalance(), depositAmount - withdrawAmount);
        assertEq(circuitBreaker.balances(user), depositAmount - withdrawAmount);
    }

    function testPause() public {
        // Test that the pause function works and emits the Paused event
        vm.prank(owner); // Simulate the owner calling the function

        // Check that the Paused event is emitted
        vm.expectEmit(true, true, true, true);
        emit Paused();

        circuitBreaker.pause();

        // Check that the contract is paused
        assertEq(circuitBreaker.paused(), true);
    }

    function testUnpause() public {
        // Test that the unpause function works and emits the Unpaused event
        vm.prank(owner); // Simulate the owner pausing the contract
        circuitBreaker.pause();

        // Check that the Unpaused event is emitted
        vm.expectEmit(true, true, true, true);
        emit Unpaused();

        vm.prank(owner); // Simulate the owner unpausing the contract
        circuitBreaker.unpause();

        // Check that the contract is not paused
        assertEq(circuitBreaker.paused(), false);
    }

    function testPauseNotOwner() public {
        // Test that only the owner can pause the contract
        address attacker = address(0x9999);

        vm.prank(attacker); // Simulate an attacker calling the function
        vm.expectRevert("Not the owner");
        circuitBreaker.pause();
    }

    function testUnpauseNotOwner() public {
        // Test that only the owner can unpause the contract
        address attacker = address(0x9999);

        vm.prank(owner); // Simulate the owner pausing the contract
        circuitBreaker.pause();

        vm.prank(attacker); // Simulate an attacker calling the function
        vm.expectRevert("Not the owner");
        circuitBreaker.unpause();
    }

    function testDepositWhenPaused() public {
        // Test that deposits are not allowed when the contract is paused
        uint256 amount = 1 ether;

        vm.prank(owner); // Simulate the owner pausing the contract
        circuitBreaker.pause();

        vm.deal(user, amount); // Fund the user with Ether
        vm.prank(user); // Simulate the user calling the function
        vm.expectRevert("Contract is paused");
        circuitBreaker.deposit{value: amount}();
    }

    function testWithdrawWhenPaused() public {
        // Test that withdrawals are not allowed when the contract is paused
        uint256 depositAmount = 1 ether;

        vm.deal(user, depositAmount); // Fund the user with Ether
        vm.prank(user); // Simulate the user depositing
        circuitBreaker.deposit{value: depositAmount}();

        vm.prank(owner); // Simulate the owner pausing the contract
        circuitBreaker.pause();

        vm.prank(user); // Simulate the user calling the function
        vm.expectRevert("Contract is paused");
        circuitBreaker.withdraw(depositAmount);
    }

    function testGetBalance() public {
        // Test that the getBalance function returns the correct balance
        uint256 amount = 1 ether;

        vm.deal(user, amount); // Fund the user with Ether
        vm.prank(user); // Simulate the user depositing
        circuitBreaker.deposit{value: amount}();

        // Check the user's balance
        assertEq(circuitBreaker.getBalance(), amount);
    }
}
