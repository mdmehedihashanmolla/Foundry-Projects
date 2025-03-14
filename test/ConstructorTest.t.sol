// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {ConstructorExample} from "../src/ConstructorExample.sol";

contract ConstructorExampleTest is Test {
    ConstructorExample public constructorExample;

    address public owner = address(0x1234);

    function setUp() public {
        vm.prank(owner);
        constructorExample = new ConstructorExample("TestContract");
    }

    function testOwner() public view {
        address contractOwner = constructorExample.getOwner();
        assertEq(contractOwner, owner);
    }
    function testContractName() public view {
        string memory contractName = constructorExample.getContractName();
        assertEq(contractName, "TestContract");
    }
    function testOwnerStateVariable() public view {
        address contractOwner = constructorExample.owner();
        assertEq(contractOwner, owner);
    }
    function testContractNameStateVariable() public view {
        string memory contractName = constructorExample.contractName();
        assertEq(contractName, "TestContract");
    }
}
