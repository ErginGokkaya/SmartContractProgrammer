// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Constants
{
    address public constant  owner2 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address public immutable owner1;

    constructor()
    {
        owner1 = msg.sender; // immutable can be set in constructor
    }
    
}