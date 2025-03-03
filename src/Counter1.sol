// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Counter1 {
    int256 public counter;

    event Counter1Update(int256 newValue);

    function increment() public {
        counter += 1;
        emit Counter1Update(counter);
    }

    function decrement() public {
        counter -= 1;

        emit Counter1Update(counter);
    }
    function getCounter1() public view returns (int256) {
        return counter;
    }
}
