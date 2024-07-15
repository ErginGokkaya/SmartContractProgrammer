// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Receiver
{
    event Log(bytes);

    function transfer(address _to, uint256 _amount) external 
    {
        emit Log(msg.data);
        // when you send 123 wei to 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
        // 0xa9059cbb : first 4 bytes are function to call (hash of function signature and its first 4 bytes)
        // 000000000000000000000000ab8483f64d9c6d1ecf9b849ae677dd3315835cb2 : first parameter
        // 000000000000000000000000000000000000000000000000000000000000007b : second parameter
    }
}

contract FunctionSelector
{
    function getSelector(string calldata _func) external pure returns(bytes4)
    {
        return bytes4(keccak256(bytes(_func))); // returns 0xa9059cbb for "transfer(address,uint256)"
    }
}