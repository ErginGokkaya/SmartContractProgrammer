// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract DefaultValues
{
    bool    public b; // false
    uint32  public x; // 0
    address public a; // 0x0...40Zeros...0
    bytes16 public by;// 0x0...32Zeros...0
    string  public s; // ""
    bytes   public bt;// 0x
}

contract ConstantValues
{
    // To use constants in code provides to save GAS
    uint256 public constant totalSupply = 10000;
    address public immutable owner;

    constructor()
    {
        owner = msg.sender;
    } 
}