// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract AbiDecode
{
    struct MyStruct
    {
        string name;
        uint256[2] nums;
    }
    function encode(uint256 x, address addr, uint256[] calldata arr, MyStruct calldata myStruct) external pure returns(bytes memory)
    {
        return abi.encode(x,addr,arr,myStruct);
    }

    // tip: when calldata used in return type: 
    // This variable is of calldata pointer type and can be returned without prior assignment, which would lead to undefined behaviour.
    function decode(bytes calldata _data) external pure returns(uint256 x, address addr, uint256[] memory arr, MyStruct memory myStruct)
    {
        (x,addr,arr,myStruct) = abi.decode(_data, (uint256,address,uint256[],MyStruct));
    }
}