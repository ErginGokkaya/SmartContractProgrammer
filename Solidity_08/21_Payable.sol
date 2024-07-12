// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
When ether is sent to the contract:
    if msg.data is empty
        if receive exist
            call receive
        else
            call fallback
    else
        call fallback
*/ 

contract ReceiveETH
{
    event Log(uint256 amoun, uint256 gas);

    receive() external payable 
    {
        emit Log(msg.value,gasleft());
    }
}

contract SendETH
{
    /*
        3 ways to send ETH
        1. transfer: sends 2300 gas.. reverts when fail
        2. send    : sends 2300 gas.. returns the bool whether the transfer is success
        3. call    : all gas.. returns bool and data
    */

    constructor() payable {} // is one way to be able to receive Ether

    function sendViaTransfer(address payable _to) external payable
    {
        _to.transfer(123);
    }
    function sendViaSend(address payable _to) external payable
    {
        bool isSent = _to.send(123);
        require(isSent,"Send Failed");
    }
    function sendViaCall(address payable _to) external payable returns(bytes memory)
    {
        (bool isSuccess, bytes memory data) = _to.call{value: 123}("");
        require(isSuccess,"Call Failed");
        return data;
    }
}

contract Payyable
{
    event LowLevelCall(string functionName, address sender, uint256 value, bytes data);
    address payable public immutable owner;

    constructor()
    {
        owner = payable(msg.sender);
    }

    // fallback function executed when
    // 1. function does not exist
    // 2. directly send ETH with data when defined payable
    fallback() external payable 
    {
        emit LowLevelCall("fallback",msg.sender,msg.value,msg.data);
    }

    receive() external payable // receive has to be identified by payable
    {
        emit LowLevelCall("receive",msg.sender,msg.value,"data doesnot exist");
    }

    function deposit() external payable{}

    function getBalance() external view returns(uint256)
    {
        return address(this).balance;
    }
}
