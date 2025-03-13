// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract FallbackExample {
    mapping(address => uint) private balances;

    event Received(address indexed sender, uint amount);

    // Function to receive Ether when msg.data is empty
    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Received(msg.sender, msg.value);
    }

    // Fallback function to accept Ether when msg.data is not empty
    fallback() external payable {
        balances[msg.sender] += msg.value;
        emit Received(msg.sender, msg.value);
    }

    function getBalance(address _user) external view returns (uint) {
        return balances[_user];
    }
}
