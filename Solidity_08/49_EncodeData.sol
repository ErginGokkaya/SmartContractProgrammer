// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Token{
    function transfer(address _to, uint256 _amount) external {}
}

contract AbiEncode{
    function test(address _contract, bytes calldata data) external {
        (bool ok,) = _contract.call(data);
        require(ok,"Failed");
    } 

    function encodeWithSignature(address _to, uint256 _amount) external pure returns(bytes memory){
        return abi.encodeWithSignature("transfer(address,uint256)", _to, _amount);
    }

    function encodeWithSelector(address _to, uint256 _amount) external pure returns(bytes memory){
        return abi.encodeWithSelector(Token.transfer.selector, _to, _amount); // can be compiled regardless of the argumnets correction
    }

    function encodeCall(address _to, uint256 _amount) external pure returns(bytes memory){
        return abi.encodeCall(Token.transfer,(_to, _amount));
    }
}