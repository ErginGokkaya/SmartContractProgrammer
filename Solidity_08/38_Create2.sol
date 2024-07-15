// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Create2
{
    address public owner;

    constructor(address _owner)
    {
        owner = _owner;
    }
}

contract CreateFactory
{
    event Deploy(address addr);

    // the addresses of deployed contracts by deploy function and getBytecode+getAddress with same salt are the same.
    function deploy(uint256 _salt) external 
    {
        // creating in regular way:
        // Create2 _contract = new Create2(msg.sender);
        // emit Deploy(address(_contract));

        // using create2:
        // using arbitrary salt parameter we can determine the contract address before deploying it.. weird ha..

        Create2 _contract = new Create2{salt: bytes32(_salt)}(msg.sender);
        emit Deploy(address(_contract));

    }

    function getAddress(bytes memory bytecode, uint256 _salt) public view returns(address)
    {
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff),address(this),_salt,keccak256(bytecode)));
        return address(uint160(uint(hash)));
    }

    function getBytecode(address _owner) public pure returns(bytes memory)
    {
        bytes memory bytecode = type(Create2).creationCode;
        return abi.encodePacked(bytecode,abi.encode(_owner));
    }
}