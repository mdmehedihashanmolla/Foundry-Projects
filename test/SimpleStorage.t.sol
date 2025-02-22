// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol"; 

contract SimpleStorageTest is Test { 
    SimpleStorage storageContract; 
    function setUp() public {
        storageContract = new SimpleStorage();
    }

    // ✅ Check if a stored value is set correctly
    function testSetValue() public {
        storageContract.setValue(42);
        assertEq(storageContract.getValue(), 42);
    }

    // ✅ Test with assertEq and require
    function testRequireCondition() public {
        vm.expectRevert("Value must be greater than zero");
        storageContract.setValue(0);
    }

    function testRevertOnInvalidInput() public {
        vm.expectRevert("Value must be greater than zero");
        storageContract.setValue(0);
    }

    function testFailOnZeroValue() public {
        vm.expectRevert("Value must be greater than zero");
        storageContract.setValue(0);
    }

    function testEmitEvent() public {
        vm.expectEmit(true, true, false, true); // ✅ Corrected event expectation
        storageContract.setValue(100); // ✅ This will trigger the ValueChanged event
    }
}
