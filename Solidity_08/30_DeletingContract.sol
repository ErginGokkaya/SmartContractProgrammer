// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Kill
{
    constructor() payable {}

    function kill() external
    {
        selfdestruct(payable(msg.sender));
    }

    function testCall() external pure returns(uint256)
    {
        return 123;
    }
}