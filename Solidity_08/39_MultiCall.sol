// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TestMultiCall
{
    function func1() external view returns(uint256,uint256)
    {
        return (1,block.timestamp);
    }

    function func2() external view returns(uint256,uint256)
    {
        return (2,block.timestamp);
    }

    function getData1() external pure returns(bytes memory)
    {
        // return abi.encodeWithSignature("func1()");
        return abi.encodeWithSelector(this.func1.selector);
    }

    function getData2() external pure returns(bytes memory)
    {
        // return abi.encodeWithSignature("func2()");
        return abi.encodeWithSelector(this.func2.selector);
    }
}

contract MultiCall
{
    function multicall(address[] calldata _targets, bytes[] calldata _data) external view returns(bytes[] memory)
    {
        require(_targets.length == _data.length, "targets must be same with data");
        uint256 length = _targets.length;
        bytes[] memory results = new bytes[](length);

        for(uint i = 0; i < length;)
        {
            // staticcall is more proper to view
            // _targets[i] : contract address
            // _data[i] : function signature
            (bool success, bytes memory data ) = _targets[i].staticcall(_data[i]);
            require(success, "Failed");
            results[i] = data;

            unchecked{i++;}
        }

        return results;
    }
}