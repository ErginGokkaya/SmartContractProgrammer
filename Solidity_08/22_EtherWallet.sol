// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract EtherWallet
{
    event Log(address sender, uint256 amount);
    address payable public immutable owner;

    constructor()
    {
        owner = payable(msg.sender);
    }

    receive() external payable 
    {
        emit Log(msg.sender,msg.value);
    }

    function withdraw(uint256 _amount) onlyOwner external 
    {
        require(_amount < address(this).balance,"Balance is not enough");
        owner.transfer(_amount);
    }

    function getBalance() external view returns(uint256)
    {
        return address(this).balance;
    }

    modifier onlyOwner()
    {
        require(owner == msg.sender,"Unauthorized Access");
        _;
    }
}