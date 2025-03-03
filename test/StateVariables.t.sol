// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {StateVariables} from "../src/StateVariables.sol";

contract StateVariablesTest is Test {
    StateVariables private stateVariables;

    address private alice = address(0x123);
    address private bob = address(0x456);

    event DateUpdated(uint256 number, address userAddress, bool flag, string text);

    function setUp() public {
        stateVariables = new StateVariables();
    }

    function testSetValues() public {
        uint256 testNumber = 42;
        bool testFlag = true;
        string memory testText = "Hi Foundry";

        vm.expectEmit(true, true, true, true);
        emit DateUpdated(testNumber, alice, testFlag, testText);

        vm.prank(alice);
        stateVariables.setValues(testNumber, alice, testFlag, testText);

        (uint256 number, address userAddress, bool flag, string memory text) = stateVariables.getValues();
        assertEq(number, testNumber, "Number Should Match");
        assertEq(userAddress, alice, "User address should match");
        assertEq(flag, testFlag, "Flag should match");
        assertEq(text, testText, "Text should match");
    }

    function testSetValuesFromDifferentSenders() public {
        uint256 testNumber1 = 100;
        uint256 testNumber2 = 200;

        bool testFlag1 = true;
        bool testFlag2 = false;
        string memory testText1 = "Alice";
        string memory testText2 = "Bob";

        vm.prank(alice);
        stateVariables.setValues(testNumber1, alice, testFlag1, testText1);

        (uint256 number, address userAddress, bool flag, string memory text) = stateVariables.getValues();

        assertEq(number, testNumber1, "Number should match Alice's Input");
        assertEq(userAddress, alice, "User address should match Alice");
        assertEq(flag, testFlag1, "Flag Should match Alice's input");
        assertEq(text, testText1, "Text should match  Alice's input");

        vm.prank(bob);
        stateVariables.setValues(testNumber2, bob, testFlag2, testText2);

        (number, userAddress, flag, text) = stateVariables.getValues();
        assertEq(number, testNumber2, "Number should match Alice's Input");
        assertEq(userAddress, bob, "User address should match Alice");
        assertEq(flag, testFlag2, "Flag Should match Alice's input");
        assertEq(text, testText2, "Text should match  Alice's input");
    }

    function testInitialState() public view {
        (uint256 number, address userAddress, bool flag, string memory text) = stateVariables.getValues();
        assertEq(number, 0, "Initial number should be 0");
        assertEq(userAddress, address(0), "Initial user address should be 0x0");
        assertEq(flag, false, "Initial flag should be false");
        assertEq(text, "", "Initial text should be empty");
    }
}
