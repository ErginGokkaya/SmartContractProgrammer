// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract VariableLifetime
{
    // state variables are variables stored on the blockchain
    uint256 public iAmAStateVariable = 123;

    function foo() public view returns(address,uint256,uint256,uint256)
    {
        uint256 iAmALocalVariable = 123; // alive only in the function brackets

        /*
        Global variables store data about blockchain, transaction etc.
        */

        address sender      = msg.sender;
        uint256 currentTime = block.timestamp; // stores unix timestamps of now
        uint256 blockNum    = block.number;

        return (sender,currentTime,blockNum,iAmALocalVariable);
    }
}