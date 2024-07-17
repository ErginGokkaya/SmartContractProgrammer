// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract UncheckedMath{
    function add(uint256 _x, uint256 _y) external pure returns(uint256) {
        // return _x + _y;
        // when you are sure this sum wont be exceed the max uint256 the use:
        unchecked{ return _x + _y;} // this saves gas
    }
    function sub(uint256 _x, uint256 _y) external pure returns(uint256) {
        // return _x - _y;
        // when you are sure that x is greater or equal than y
        unchecked{ return _x - _y;}
    }
}