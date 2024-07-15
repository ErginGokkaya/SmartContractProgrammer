// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract PiggyBank
{
    event Log(address sender, uint256 amount);

    address payable public immutable owner;

    constructor()
    {
        owner = payable(msg.sender);
    }

    modifier onlyOwner()
    {
        require(msg.sender == owner,"Unauthorized Access");
        _;
    }

    receive() external payable 
    {
        emit Log(msg.sender, msg.value);
    }

    function withdraw() onlyOwner external payable
    {
        emit Log(msg.sender,address(this).balance);
        selfdestruct(owner);
    }
}