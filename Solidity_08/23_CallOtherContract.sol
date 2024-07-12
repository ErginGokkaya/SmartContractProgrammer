// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract CallTestContract
{
    function setX(address _testContract, uint256 _x) external
    {
        // way 1 to call other contract
        TestContract(_testContract).setX(_x);
    } 
    function setX2(TestContract _test, uint256 _x) external 
    {
        _test.setX(_x);
    }
    function sendETH(address _test, uint256 _x, uint256 _amount) external payable 
    {
        // TestContract(_test).receiveEther{value: msg.value}(_x);
        TestContract(_test).receiveEther{value: _amount}(_x);
    }
}

contract TestContract
{
    uint256 public x;
    uint256 public value = 123;

    function setX(uint256 _x) external 
    {
        x = _x;
    }
    function getX() external view returns(uint256)
    {
        return x;
    }
    function receiveEther(uint256 _x) external payable 
    {
        x = _x;
        value = msg.value;
    }
    function getXandValue() external view returns(uint256, uint256)
    {
        return (x,value);
    }
}