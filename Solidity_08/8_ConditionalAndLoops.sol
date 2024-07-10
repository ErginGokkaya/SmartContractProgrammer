// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Conditional
{
    function getEvenOdd(uint256 num) external pure returns(string memory)
    {
        if(num%2 == 0)
        {
            return "num is even!";
        }
        else
        {
            return "num is odd!";
        }
    }

    function ternaryComparison(uint256 num1, uint num2) external pure returns(uint256)
    {
        return num1 >= num2 ? num1:num2;
    }
}

contract Loops
{
    function loop10Times() external pure
    {
        for(uint256 i = 0; i < 10; )
        {
            if(i == 3)
                continue;
            else if (i == 7)
                break;

            unchecked{i++;}
        }
    }
}