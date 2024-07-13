// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract HashFunc
{
    function hash(string memory text, uint256 num, address addr) external pure returns(bytes32)
    {
        // encodePacked may result in hash collusion because it generates same result for "AAA","BBB" and "AA","ABBB"
        return keccak256(abi.encodePacked(text,num,addr));
    }

    function encode(string memory text1, string memory text2) external pure returns(bytes memory)
    {
        return abi.encode(text1,text2);
    }
    function encodePacked(string memory text1, string memory text2) external pure returns(bytes memory)
    {
        return abi.encodePacked(text1,text2);
    }

}