// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Functions
{
    function add(uint256 num1, uint num2) external pure returns(uint256)
    {
        return num1 + num2;
    }

    function multiply(int256 num1, int num2) public pure returns(int256)
    {
        return num1 * num2;
    }

    function square(int256 num) external pure returns(int256)
    {
        return multiply(num,num);
    }
}