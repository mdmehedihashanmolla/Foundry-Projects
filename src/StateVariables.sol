// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract StateVariables {
    uint256 public number;
    address public userAddress;
    bool public flag;
    string public text;

    event DateUpdated(uint256 number, address userAddress, bool flag, string text);

    function setValues(uint256 _number, address _userAddress, bool _flag, string memory _text) public {
        number = _number;
        userAddress = _userAddress;
        flag = _flag;
        text = _text;

        emit DateUpdated(_number, _userAddress, _flag, _text);
    }

    function getValues() public view returns (uint256, address, bool, string memory) {
        return (number, userAddress, flag, text);
    }
}
