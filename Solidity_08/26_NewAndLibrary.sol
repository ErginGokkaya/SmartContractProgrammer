// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 2 ways to create a contract from another contract.. create and create2.. lets dive in

contract Account
{
    address public owner;
    address public bank;
    constructor (address _owner) payable 
    {
        bank = msg.sender;
        owner = _owner;
    }
}

contract AccountFactory
{
    Account[] public accounts;
    function createAccount(address _owner) external payable 
    {
        Account account = new Account{value: 111 wei}(_owner);
        accounts.push(account);
    }

}

//-------------------------------
// library cannot declare state variables
library Math
{
    // internal allows us to call the function without deploying the library
    function max(uint256 _num1, uint256 _num2) internal pure returns(uint256)
    {
        return _num1 >= _num2 ? _num1 : _num2;
    }
}

contract TestLibrary
{
    using Math for uint256;
    function testMax(uint256 _num1, uint256 _num2) external pure returns(uint256)
    {
        //return Math.max(_num1, _num2);
        return _num1.max(_num2);
    }
}