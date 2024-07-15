// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract MultiDelegateCall
{
    function multDelegateCall(bytes[] calldata _data) external payable returns(bytes[] memory)
    {
        require(_data.length > 0, "data empty");
        uint256 length = _data.length;
        bytes[] memory results = new bytes[](length);

        for(uint256 i = 0; i < length; )
        {
            (bool success, bytes memory data) = address(this).delegatecall(_data[i]);
            require(success,"failed");
            results[i] = data;
            unchecked{i++;}
        }

        return results;
    }
}

contract Test is MultiDelegateCall
{
    event Log(address caller, string func, uint256 i);

    function func1(uint256 x, uint256 y) external
    {
        emit Log(msg.sender,"func1", x+y);
    }

    function func2() external returns(uint256)
    {
        emit Log(msg.sender,"func2", 2);
        return 111;
    }

}

contract Helper
{
    function getFunc1Data(uint256 x, uint256 y) external pure returns(bytes memory)
    {
        return abi.encodeWithSelector(Test.func1.selector, x,y);
    }

    function getFunc2Data() external pure returns(bytes memory)
    {
        return abi.encodeWithSelector(Test.func2.selector);
    }
}