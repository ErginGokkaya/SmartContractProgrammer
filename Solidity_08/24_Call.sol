// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TestCall
{
    string  public message;
    uint256 public x;

    event Log(string message);

    fallback() external payable 
    {
        emit Log("Fallback called");
    }

    receive() external payable {}

    function foo(string memory _message, uint256 _x) external payable returns(uint256, bool)
    {
        message = _message;
        x = _x;
        return (777,true);
    }
}

contract Call
{
    bytes public data;
    function callFoo(address _contractAddress) external payable returns(bool)
    {
        (bool success, bytes memory _data ) = _contractAddress.call{value: 111 wei, gas: 50000}(abi.encodeWithSignature("foo(string,uint256)","i can call foo",123));
        require(success, "Foo call failed");
        data = _data;
        return success;
    }

    function callNotExistFoo(address _contractAddress) external 
    {
        (bool success,) = _contractAddress.call(abi.encodeWithSignature("bar(string,uint256)","NotExist",321));
        require(success,"Failed");
    }
}