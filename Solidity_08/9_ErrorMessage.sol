// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 4 possible ways:
// - require
// - revert
// - assert
// - custom error after 0.8

contract ErrorMessages
{
    error SendError(address caller, uint256 input);

    function testRequire(uint256 _i) external pure returns(uint256)
    {
        require(_i < 10,"i must be less than 10");

        return _i * _i;
    }

    function testRevert(uint256 _i) external pure returns(uint256)
    {
        if(_i >= 10)
            revert("i must be less than 10"); // for nested if statements revert is better than require
        
        return _i * _i;
    }

    function testAssert(uint256 _i) external pure returns(uint256)
    {
        assert(_i < 10);
        return _i * _i;
    }

    function testError(uint256 _i) external view returns(uint256)
    {
        if(_i > 10)
            revert SendError(msg.sender, _i); // sending error is a cheaper way to print the error message

        return _i *_i;
    }
}