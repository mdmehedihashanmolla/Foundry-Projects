// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {Parent, Child} from "../src/Inheritance.sol";

contract ParentChildTest is Test {
    Parent public parent;
    Child public child;

    function setUp() public {
        parent = new Parent("ParentContract");

        child = new Child("ChildContract", 10);
    }

    function testParentName() public view {
        string memory name = parent.getName();
        assertEq(name, "ParentContract");
    }

    function testChildName() public view {
        string memory name = child.getName();
        assertEq(name, "ChildContract");
    }

    function testChildAge() public view {
        uint age = child.getAge();
        assertEq(age, 10);
    }
}
