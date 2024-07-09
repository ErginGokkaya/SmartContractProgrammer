// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract SafeMath
{
    function testUnderflow() public pure returns(uint8)
    {
        uint8 x = 0;
        unchecked{ x--; }
        return x; // returns 255
    }
}

contract CustomError
{
    address payable public owner;

    error Unauthorized(address caller); // cheaper alternative in terms of gas usage

    constructor()
    {
        owner = payable(msg.sender);
    }

    function withdraw() public
    {
        if(msg.sender != owner)
            revert Unauthorized(msg.sender); //revert("error");
        
        owner.transfer(address(this).balance);
    }
}

// free functions cannot have visibility
// mutability is restricted by pure
function helper(uint256 x) pure returns(uint256) 
{
    return x*x;
}

/*
When another contract want to include the free functions and events:
import {helper} from "./1_NewFeatures.sol"
Use alias for the variables already exist in current file
import {symbol1, symbol2 as alias2} from "filename"

*/

contract D
{
    uint256 public x;
    constructor(uint256 a)
    {
        x = a;
    }
}

contract Create2
{
    function getBytes32(uint256 _salt) external pure returns(bytes32)
    {
        return bytes32(_salt);
    }

    function getAddress(bytes32 _salt, uint256 _arg) external view returns(address)
    {
        address addr = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            _salt,
            keccak256(abi.encodePacked(
                type(D).creationCode,
                _arg
            ))
        )))));

        return addr;
    }
    address public deployedAddr;

    function createDSalted(bytes32 _salt, uint256 _arg) public 
    {
        D d = new D{salt: _salt}(_arg);
        deployedAddr = address(d);
    }

}
