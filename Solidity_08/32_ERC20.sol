// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface IERC20
{
    function totalSupply() external view returns(uint256);
    function balanceOf(address _account) external view returns(uint256);
    function transfer(address _recipient, uint256 _amount) external returns(bool);
    function allowance(address _owner, address _spender) external view returns(uint256);
    function approve(address _spender, uint256 _amount) external returns(bool);
    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed from, address indexed to, uint256 amount);
}

contract ERC20 is IERC20
{
    uint256 public _totalSupply;
    mapping(address => uint256) public _balanceOf; // account => balance
    mapping(address => mapping(address => uint256)) public _allowance; // account => spender => allowed amount

    string public name     = "Test";
    string public symbol   = "TST";
    uint8  public decimals = 18; 

    function totalSupply() external view returns(uint256)
    {
        
    }
    function balanceOf(address _account) external view returns(uint256)
    {

    }
    function transfer(address _recipient, uint256 _amount) external returns(bool)
    {
        require(_amount <= _balanceOf[msg.sender],"Insufficient Balance");
        _balanceOf[msg.sender] -= _amount;
        _balanceOf[_recipient] += _amount;


        emit Transfer(msg.sender, _recipient, _amount);
        return true;
    }
    function allowance(address _owner, address _spender) external view returns(uint256)
    {
        
    }
    function approve(address _spender, uint256 _amount) external returns(bool)
    {
        _allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender,_spender,_amount);
        return true;
    }
    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns(bool)
    {
        _allowance[_sender][msg.sender] -= _amount;
        _balanceOf[_sender] -= _amount;
        _balanceOf[_recipient] += _amount;

        emit Transfer(_sender,_recipient,_amount);
        return true;
    }

    function mint(uint256 _amount) external
    {
        _balanceOf[msg.sender] += _amount;
        _totalSupply += _amount;
        emit Transfer(address(0), msg.sender,_amount);
    }

    function burn(uint256 _amount) external
    {
        _balanceOf[msg.sender] -= _amount;
        _totalSupply -= _amount;
        emit Transfer( msg.sender,address(0),_amount);
    }
}