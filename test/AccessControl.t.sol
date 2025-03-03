// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {AccessControl} from "../src/AccessControl.sol";

contract AccessControlTest is Test {
    AccessControl private accessControl;

    address private owner = address(0x123);
    address private newOwner = address(0x456);
    address private nonOwner = address(0x789);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function setUp() public {
        vm.prank(owner);
        accessControl = new AccessControl();
    }

    function testInitialOwner() public view {
        assertEq(accessControl.owner(), owner, "Initial owner should be set correctly");
    }

    function testChangeOwner() public {
        vm.expectEmit(true, true, true, true);
        emit OwnershipTransferred(owner, newOwner);

        vm.prank(owner);
        accessControl.changeOwner(newOwner);

        assertEq(accessControl.owner(), newOwner, "Owner should be updated to newOwner");
    }

    function testChangeOwnerByNonOwner() public {
        vm.prank(nonOwner);
        vm.expectRevert("Not the owner");
        accessControl.changeOwner(newOwner);
        assertEq(accessControl.owner(), owner, "Owner should not change when called by non-owner");
    }

    function testMultipleOwnershipTransfers() public {
        address secondNewOwner = address(0xABC);

        vm.prank(owner);
        accessControl.changeOwner(newOwner);
        assertEq(accessControl.owner(), newOwner, "Owner should be updated to newOwner");

        vm.prank(newOwner);
        accessControl.changeOwner(secondNewOwner);

        assertEq(accessControl.owner(), secondNewOwner, "Owner should be updated to secondNewOwner");
    }
}
