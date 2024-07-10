// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Ownable
{
    address public owner;
    uint256 public totalSupply;

    constructor(uint256 _totalSupply)
    {
        owner = msg.sender;
        totalSupply = _totalSupply;
    }

    modifier onlyOwner()
    {
        require(msg.sender == owner,"Unauthorized Access");
        _;
    }

    function mint(uint256 amount) external onlyOwner
    {
        totalSupply += amount;
    }
}