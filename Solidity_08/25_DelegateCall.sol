// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
A calls B, sends 100 wei
        B calls C, sends 50 wei
A --> B --> C
            msg.sender = B
            msg.value  = 50
            execute code on C's state variables
            use ETH in C

A calls B, sends 100 wei
        B delegatecall C
A --> B --> C
            msg.sender = A
            msg.value  = 100
            execute code on B's state variables
            use ETH in B
*/

contract TestDelegateCall
{
    // state variable order is soooo important in terms of storage layout
    // order has to be same order with the delegate contract
    // otherwise results are unexcepted.
    // any new variable can be added after original variables
    uint256 public num;
    uint256 public value;
    address public sender;

    function setVars(uint256 _num) external payable 
    {
        num    = _num;
        value  = msg.value;
        sender = msg.sender;
    }
}

contract DelegateCall
{
    uint256 num;
    uint256 value;
    address sender;

    function setVars(address _test, uint256 _num) external payable 
    {
        (bool success, ) = _test.delegatecall(abi.encodeWithSignature("setVars(uint256)",_num));
        // alternative: benefits of this is when the signature of function changes this still works
        //(bool success, bytes memory data) = _test.delegatecall(abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num));
        require(success,"failed");
    }
}

// Why is delegatecall used?? weird: call anothet contract's function and update calling contract
// you deployed the contract B and later you would like to update num = 2* _num;
// deploy another contract with the updated method.. then delegatecall it from first deployed contract