// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {Counter1} from "../src/Counter1.sol";

contract Counter1Test is Test {
    Counter1 private counter;

    event Counter1Update(int256 newValue);

    function setUp() public {
        counter = new Counter1();
    }

    function testInitialCounter() public view {
        int256 currentCounter = counter.getCounter1();
        assertEq(currentCounter, 0, "Initial counter value should be 0");
    }

    function testIncrement() public {
        vm.expectEmit(true, true, true, true);
        emit Counter1Update(1);

        counter.increment();

        int256 currentCounter = counter.getCounter1();
        assertEq(currentCounter, 1, "Counter should be incremented to 1");
    }

    function testDecrement() public {
        counter.increment();
        vm.expectEmit(true, true, true, true);
        emit Counter1Update(0);
        counter.decrement();

        int256 currentCounter = counter.getCounter1();
        assertEq(currentCounter, 0, "Counter should be decremented to 0");
    }

    function testMultipleIncrements() public {
        counter.increment();
        counter.increment();
        counter.increment();

        int256 currentCounter = counter.getCounter1();
        assertEq(currentCounter, 3, "Counter should be incremented to 3");
    }

    function testMultipleDecrements() public {
        for (int256 i = 0; i < 5; i++) {
            counter.increment();
        }

        counter.decrement();
        counter.decrement();
        counter.decrement();

        int256 currentCounter = counter.getCounter1();
        assertEq(currentCounter, 2, "Counter should be decremented to 2");
    }

    function testIncrementAndDecrement() public {
        counter.increment();
        counter.increment();

        counter.decrement();

        int256 currentCounter = counter.getCounter1();
        assertEq(currentCounter, 1, "Counter should be 1 after incrementing twice and decrementing once");
    }
}
