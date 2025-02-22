// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage storageContract;

    event ValueChanged(uint256 newValue);

    function setUp() public {
        storageContract = new SimpleStorage();
    }

    function testSetValue() public {
        storageContract.setValue(42);
        assertEq(storageContract.getValue(), 42);
    }

    function testRequireCondition() public {
        vm.expectRevert("Value must be greater than zero");
        storageContract.setValue(0);
    }

    function testRevertOnInvalidInput() public {
        vm.expectRevert("Value must be greater than zero");
        storageContract.setValue(0);
    }

    function test_Revert_When_ValueIsZero() public {
        vm.expectRevert("Value must be greater than zero");
        storageContract.setValue(0);
    }

    function testEmitEvent() public {
        vm.expectEmit(true, true, false, true);
        emit ValueChanged(100); // Specify expected event
        storageContract.setValue(100);
    }
}
