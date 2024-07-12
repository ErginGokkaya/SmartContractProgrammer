// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Events
{
    // cheap alternative to store data to blockchain but not to smart contract
    event Log(string message, uint256 value);
    // indexed enables us to search for our keyword.. up to 3 indexed parameters are accepted
    event IndexedLog(address indexed sender, uint256 value);
    event Message(address indexed _from, address indexed _to, string message);

    function examples() external
    {
        emit Log("foo",123);
        emit IndexedLog(msg.sender, 456);
    }

    function sendMessage(address _toAddress) external
    {
        emit Message(msg.sender,_toAddress,"Send me ETH");
    }

}