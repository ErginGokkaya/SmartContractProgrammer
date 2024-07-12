// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
private : only inside the contract
internal: only inside the contract and its children
public  : inside and outside the contract
external: outside the contract
*/

contract A
{
    uint256 private  x = 10;
    uint256 internal y = 20;
    uint256 public   z = 30;
    //uint256 external cannot be declared

    function foo() private pure returns(uint256)
    {
        return 100;
    }

    function bar() internal pure returns(uint256)
    {
        return 200;
    }

    function tar() public pure returns(uint256)
    {
        return 300;
    }

    function zar() external pure returns(uint256)
    {
        return 400;
    }

    function examples() public view
    {
        // zar() cannot be called here.. compile error
        this.zar(); // a trick to call external
    }
}

contract B is A
{
    function examplesB() public view 
    {
        // foo() and zar cannot be called
        // x is unreachable
    }
}

contract C
{
    //foo, bar, x, y cannot be accessed
}