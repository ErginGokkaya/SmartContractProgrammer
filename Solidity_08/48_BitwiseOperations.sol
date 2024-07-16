// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Bitwise{
    function and(uint256 _x, uint256 _y) external pure returns(uint256){
        return _x & _y;
    }
    function or(uint256 _x, uint256 _y) external pure returns(uint256){
        return _x | _y;
    }
    function xor(uint256 _x, uint256 _y) external pure returns(uint256){
        return _x ^_y;
    }
    function not(uint256 _x) external pure returns(uint256){
        return ~_x;
    }
    function shiftLeft(uint256 _x, uint256 bits) external pure returns(uint256){
        return _x << bits; // 0001 << 2 => 0100.. shiftLeft(1,2) = 4 
    }
    function shiftRight(uint256 _x, uint256 bits) external pure returns(uint256){
        return _x >> bits;
    }
    function getLastNBits(uint256 _x, uint256 _n) external pure returns(uint256){
        return _x & (( 1 << _n) - 1);
    }
}