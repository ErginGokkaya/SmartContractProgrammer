// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Multiple inheritance has to be most base_like order, otherwise not compile: Grandchild is Parent, Child 

contract Parent
{
    function foo() public pure virtual returns(string memory)
    {
        return "A.foo";
    }

    function bar() public pure virtual returns(string memory)
    {
        return "A.bar";
    }

    function tar() public pure returns(string memory)
    {
        return "A.tar";
    }
}

contract Child is Parent
{
    function foo() public pure virtual override returns(string memory)
    {
        return "B.foo";
    } 
}

contract Grandchild is Child
{
        function foo() public pure override returns(string memory)
    {
        return "C.foo";
    } 
}

contract S
{
    string name;
    constructor(string memory _name)
    {
        name = _name;
    }
}

contract T
{
    string text;
    constructor(string memory _text)
    {
        text = _text;
    }
}

// 1st type of parent constructor call when the static inputs are determined in compile time
contract U is S("s"),T("t")
{

}

// 2nd type of parent constructor call for dynamic inputs
contract V is S,T
{
    constructor(string memory _name, string memory _text) S(_name) T(_text)
    {

    }
}