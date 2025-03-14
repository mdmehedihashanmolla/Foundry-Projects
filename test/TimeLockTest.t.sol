// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {TimeLockContract} from "../src/TimeLockContract.sol";

contract TimeLockContractTest is Test {
    TimeLockContract public timeLockContract;
    address public owner = address(0x1234); // Address to use as the owner
    uint256 public lockDuration = 1 days; // Lock duration for testing

    event FundsDeposited(address indexed sender, uint256 amount, uint256 unlockTime);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    function setUp() public {
        // Deploy the TimeLockContract with a lock duration
        vm.prank(owner); // Simulate the owner deploying the contract
        timeLockContract = new TimeLockContract(lockDuration);
    }

    function testOwner() public {
        // Test that the owner is set correctly
        address contractOwner = timeLockContract.owner();
        assertEq(contractOwner, owner);
    }

    function testUnlockTime() public {
        // Test that the unlockTime is set correctly
        uint256 expectedUnlockTime = block.timestamp + lockDuration;
        uint256 contractUnlockTime = timeLockContract.unlockTime();
        assertEq(contractUnlockTime, expectedUnlockTime);
    }

    function testReceiveEther() public {
        // Test that the contract can receive Ether and emits the FundsDeposited event
        uint256 amount = 1 ether;
        vm.deal(address(timeLockContract), amount); // Send Ether to the contract

        // Check the contract balance
        assertEq(address(timeLockContract).balance, amount);

        // Check that the FundsDeposited event is emitted
        vm.expectEmit(true, true, true, true);
        emit FundsDeposited(address(this), amount, timeLockContract.unlockTime());
        (bool success,) = address(timeLockContract).call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    function testWithdrawFundsBeforeUnlock() public {
        // Test that funds cannot be withdrawn before the unlock time
        uint256 amount = 1 ether;
        vm.deal(address(timeLockContract), amount); // Send Ether to the contract

        vm.prank(owner); // Simulate the owner calling the function
        vm.expectRevert("Funds are locked");
        timeLockContract.withdrawFunds();
    }

    function testWithdrawFundsAfterUnlock() public {
        // Test that funds can be withdrawn after the unlock time
        uint256 amount = 1 ether;
        vm.deal(address(timeLockContract), amount); // Send Ether to the contract

        // Fast-forward time to after the unlock time
        vm.warp(block.timestamp + lockDuration + 1);

        // Check that the FundsWithdrawn event is emitted
        vm.expectEmit(true, true, true, true);
        emit FundsWithdrawn(owner, amount);

        vm.prank(owner); // Simulate the owner calling the function
        timeLockContract.withdrawFunds();

        // Check that the contract balance is now 0
        assertEq(address(timeLockContract).balance, 0);

        // Check that the owner received the funds
        assertEq(owner.balance, amount);
    }

    function testWithdrawFundsNotOwner() public {
        // Test that only the owner can withdraw funds
        address attacker = address(0x9999);

        vm.prank(attacker); // Simulate an attacker calling the function
        vm.expectRevert("Not the owner");
        timeLockContract.withdrawFunds();
    }

    function testTimeLeft() public {
        // Test that timeLeft returns the correct remaining time
        uint256 initialTimeLeft = timeLockContract.timeLeft();
        assertEq(initialTimeLeft, lockDuration);

        // Fast-forward time by half the lock duration
        vm.warp(block.timestamp + lockDuration / 2);
        uint256 halfTimeLeft = timeLockContract.timeLeft();
        assertEq(halfTimeLeft, lockDuration / 2);

        // Fast-forward time to after the unlock time
        vm.warp(block.timestamp + lockDuration);
        uint256 finalTimeLeft = timeLockContract.timeLeft();
        assertEq(finalTimeLeft, 0);
    }
}
