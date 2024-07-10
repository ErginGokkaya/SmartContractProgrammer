// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract FunctionModifier
{
    bool private isPaused;
    uint private count;

    modifier whenNotPaused()
    {
        require(!isPaused,"Paused");
        _;
    }

    modifier checkIncrement(uint256 _x)
    {
        require(_x < 100, "Increment should be less than 100");
        _;
    }

    function setPaused(bool _paused) external
    {
        isPaused = _paused;
    }

    function increase() external whenNotPaused
    {
        count++;
    }

    function decrease() external whenNotPaused
    {
        count--;
    }

    function increaseBy(uint256 _x) external whenNotPaused checkIncrement(_x)
    {
        count += _x;
    }
}