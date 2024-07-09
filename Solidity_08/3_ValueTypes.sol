// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/* Data Types:
    value: bool, int...
    reference: array, string...
*/
contract ValueTypes
{
    bool   public flag = true;
    uint32 public unsignedInteger = 2345; // uintx equals to [0..2**x - 1]
    int64  public integer = -1234;

    int8    public minInteger = type(int8).min;
    int8    public maxInteget = type(int8).max;

    address public owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    bytes19 public _address = 0x38Da6a701c568545dCfcB03FcB875f56beddC4;

}