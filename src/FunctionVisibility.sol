// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract FunctionVisibility {
    string public publicMessage = "Public Function Called";
    string private privateMessage = "Private Function Called";
    string internal internalMessage = "Internal Function Called";

    // Public function - accessible from anywhere
    function publicFunction() public pure returns (string memory) {
        return "Public Function";
    }

    // Private function - accessible only within this contract
    function privateFunction() private pure returns (string memory) {
        return "Private Function";
    }

    // Internal function - accessible within this contract and derived contracts
    function internalFunction() internal pure returns (string memory) {
        return "Internal Function";
    }

    // External function - accessible only from outside the contract
    function externalFunction() external pure returns (string memory) {
        return "External Function";
    }

    // Testing private function (called internally)
    function testPrivateFunction() public pure returns (string memory) {
        return privateFunction();
    }

    // Testing internal function (called internally)
    function testInternalFunction() public pure returns (string memory) {
        return internalFunction();
    }
}

// Contract to test `internal` function behavior
contract DerivedContract is FunctionVisibility {
    function callInternalFunction() public pure returns (string memory) {
        return internalFunction();
    }
}
