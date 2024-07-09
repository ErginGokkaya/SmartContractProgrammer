// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Greetings
{
    string private greeting = "Hello World";

    function sayHello() public view returns(string memory)
    {
        return greeting;
    }
}