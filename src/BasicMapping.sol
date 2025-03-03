// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract BasicMapping {
    mapping(address => uint256) private balances;

    event BalanceUpdated(address indexed user, uint256 newBalance);

    function setBalance(uint256 _amount) public {
        balances[msg.sender] = _amount;
        emit BalanceUpdated(msg.sender, _amount);
    }

    function getBalance(address _user) public view returns (uint256) {
        return balances[_user];
    }
}
