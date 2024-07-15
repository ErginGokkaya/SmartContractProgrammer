// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Vault{
    ERC20 public immutable token;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor(address _token){
        token = ERC20(_token);
    }

    function _mint(address _to, uint256 _amount) private {
        totalSupply += _amount;
        balanceOf[_to] += _amount;
    }

    function _burn(address _from, uint256 _amount) private {
        totalSupply -= _amount;
        balanceOf[_from] -= _amount;
    }

    function deposit(uint256 _amount) external payable{
        // s = aT/B
        uint256 shares;

        if(totalSupply == 0){
            shares = _amount;
        }
        else{
            shares = (_amount * totalSupply) / token.balanceOf(address(this));
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender,address(this),_amount);
    }

    function withdraw(uint256 _shares) external{
        // a = sB / T

        uint256 amount = _shares * token.balanceOf(address(this)) / totalSupply;

        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);

    }

    
}