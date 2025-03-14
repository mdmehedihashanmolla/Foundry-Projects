// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {KillSwitchContract} from "../src/KillSwitchContract.sol";

contract KillSwitchContractTest is Test {
    KillSwitchContract public killSwitchContract;

    address public owner = address(0x1234);
    address public recipient = address(0x5678);

    function setUp() public {
        vm.prank(owner);
        killSwitchContract = new KillSwitchContract();
    }

    function testOwner() public view {
        address contractOwner = killSwitchContract.owner();
        assertEq(contractOwner, owner);
    }
    function testDisabledInitialState() public view {
        bool isDisabled = killSwitchContract.isDisabled();
        assertEq(isDisabled, false);
    }
    function testDisabledContract() public {
        uint amount = 1 ether;
        vm.deal(address(killSwitchContract), amount);

        assertEq(killSwitchContract.getBalance(), amount);

        vm.prank(owner);
        killSwitchContract.disableContract(payable(recipient));

        bool isDisabled = killSwitchContract.isDisabled();
        assertEq(isDisabled, true);

        assertEq(killSwitchContract.getBalance(), 0);

        assertEq(recipient.balance, amount);
    }
    function testDisableContractNotOwner() public {
        address attacker = address(0x9999);

        vm.prank(attacker);
        vm.expectRevert("Only owner can execute this");
        killSwitchContract.disableContract(payable(recipient));
    }
    function testSomeFunctionWhenActive() public {
        killSwitchContract.someFunction();
    }
    function testSomeFunctionWhenDisabled() public {
        vm.prank(owner);
        killSwitchContract.disableContract(payable(recipient));

        vm.expectRevert("Contract is disabled");
        killSwitchContract.someFunction();
    }

    function testReceiveEther() public {
        uint amount = 1 ether;
        vm.deal(address(killSwitchContract), amount);
        assertEq(killSwitchContract.getBalance(), amount);
    }

    function testGetBalance() public {
        uint amount = 1 ether;
        vm.deal(address(killSwitchContract), amount);
        assertEq(killSwitchContract.getBalance(), amount);
    }
}
