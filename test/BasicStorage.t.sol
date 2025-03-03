// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BasicStorage} from "../src/BasicStorage.sol";

contract BasicStorageTest is Test {
    BasicStorage private basicStorage;

    event NumberStored(uint256 newValue);

    function setUp() public {
        basicStorage = new BasicStorage();
    }

    function testStoreAndRetrieve() public {
        uint256 testNumber = 42;
        vm.expectEmit(true, true, true, true);
        emit NumberStored(testNumber);
        basicStorage.store(testNumber);

        uint256 retrievedNumber = basicStorage.retrieve();
        assertEq(retrievedNumber, testNumber, "The retrieved number should match the stored number");
    }

    function testInitialRetrieve() public view {
        uint256 retrievedNumber = basicStorage.retrieve();
        assertEq(retrievedNumber, 0, "The initial stored number should be 0");
    }

    function testStoreMultipleTimes() public {
        uint256 firstNumber = 10;
        uint256 secondNumber = 20;

        basicStorage.store(firstNumber);

        uint256 retrievedNumber = basicStorage.retrieve();
        assertEq(retrievedNumber, firstNumber, "The retrieved number should match the first stored Number");
        basicStorage.store(secondNumber);

        retrievedNumber = basicStorage.retrieve();

        assertEq(retrievedNumber, secondNumber, "The retrieved number should match the second scored number");
    }
}
