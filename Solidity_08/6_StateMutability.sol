// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract StateMutability
{
    uint256 private someValue = 10;

    /*
    view : reads value from blockchain and writes nothing
    pure : reads and writes nothing to blockchain
    */
    function getValue() external view returns(uint256)
    {
        return someValue;
    }

    function sumTwo(int256 num1, int256 num2) external pure returns(int256)
    {
        return num1+num2;
    }
}