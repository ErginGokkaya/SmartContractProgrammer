// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// TestFallback -->FallbackInOut --> Counter

// After solidity 0.8 fallback has input and output in bytes format
contract FallbackInOut{
    address immutable target;

    constructor(address _target){
        target = _target;
    }

    fallback(bytes calldata data) external payable returns(bytes memory){
        (bool success,bytes memory result) = target.call{value: msg.value}(data);
        require(success, "Failed");
        return result;
    }
}

contract Counter{
    uint256 public counter;

    function inc() external returns(uint256){
        return counter++;
    }
}

contract TestFallback{
    function test(address _fallback, bytes calldata data) external {
        (bool success,) = _fallback.call(data);
        require(success, "Failed");
    }

    function getTestData() external pure returns(bytes memory) {
        return abi.encodeCall(Counter.inc, ()); // () is for empyt input argument
    }
}