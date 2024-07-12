// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TestContract1
{
    address public owner = msg.sender;
    
    modifier onlyOwner()
    {
        require(msg.sender == owner,"Unauthorized Access");
        _;
    }

    function setOwner(address _owner) public onlyOwner 
    {
        owner = _owner;        
    }
}

contract TestContract2
{
    address public owner = msg.sender;
    uint256 public value = msg.value;
    uint256 public x;
    uint256 public y;

    constructor(uint256 _x, uint256 _y) payable
    {
        x = _x;
        y = _y;
    }
}

contract Proxy
{
    event Deployed(address contractAddress); 

    fallback() external payable{}
    receive() external payable{}

    function deploy(bytes memory _contractCode) external payable returns(address _contractAddress) 
    {
        assembly
        {
            // create(v,p,n)
            // v: amount of ETH to send
            // p: pointer in memory to start of code
            // n: size of code
            // use callvalue() instead of msg.value
            // first 32 bytes of the _contractCode encodes the length of the code
            // actual code starts after that
            _contractAddress := create(callvalue(),add(_contractCode, 0x20), mload(_contractCode)) 
        }

        require(_contractAddress != address(0), "Contract Creation Failed");

        emit Deployed(_contractAddress);
    }

    function execute(address _target, bytes memory _data) external payable
    {
        (bool success, ) = _target.call{value: msg.value}(_data);
        require(success, "Failed"); 
    }
}

contract Helper
{
    function getByteCode1() external pure returns(bytes memory)
    {
        bytes memory bytecode = type(TestContract1).creationCode;
        return bytecode;
    }

    function getByteCode2(uint256 _x, uint256 _y) external pure returns(bytes memory)
    {
        bytes memory bytecode = type(TestContract2).creationCode;
        return abi.encodePacked(bytecode,abi.encode(_x, _y));
    }

    function getCallData(address _owner) external pure returns(bytes memory)
    {
        return abi.encodeWithSignature( "setOwner(address)", _owner);
    }
}