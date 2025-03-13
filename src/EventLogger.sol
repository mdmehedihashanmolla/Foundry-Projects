// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract EventLogger {
    mapping(address => uint) private balances;

    event Deposited(address indexed user, uint amount);
    event Withdrawn(address indexed user, uint amount);

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawn(msg.sender, _amount);
    }

    function getBalance(address _user) public view returns (uint) {
        return balances[_user];
    }
}
