// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {FunctionVisibility, DerivedContract} from "../src/FunctionVisibility.sol";

contract FunctionVisibilityTest is Test {
    FunctionVisibility functionVisibility;
    DerivedContract derivedContract;

    function setUp() public {
        // Deploy the FunctionVisibility contract
        functionVisibility = new FunctionVisibility();
        // Deploy the DerivedContract
        derivedContract = new DerivedContract();
    }

    // Test public function
    function testPublicFunction() public view {
        string memory result = functionVisibility.publicFunction();
        assertEq(result, "Public Function", "Public function should return 'Public Function'");
    }

    // Test public message
    function testPublicMessage() public view {
        string memory result = functionVisibility.publicMessage();
        assertEq(result, "Public Function Called", "Public message should be 'Public Function Called'");
    }

    // Test private function via internal test function
    function testPrivateFunction() public view {
        string memory result = functionVisibility.testPrivateFunction();
        assertEq(result, "Private Function", "Private function should return 'Private Function'");
    }

    // Test internal function via internal test function
    function testInternalFunction() public view {
        string memory result = functionVisibility.testInternalFunction();
        assertEq(result, "Internal Function", "Internal function should return 'Internal Function'");
    }

    // Test internal function in derived contract
    function testInternalFunctionInDerivedContract() public view {
        string memory result = derivedContract.callInternalFunction();
        assertEq(result, "Internal Function", "Internal function in derived contract should return 'Internal Function'");
    }

    // Test external function
    function testExternalFunction() public view {
        // External functions can only be called from outside the contract
        string memory result = functionVisibility.externalFunction();
        assertEq(result, "External Function", "External function should return 'External Function'");
    }
}
