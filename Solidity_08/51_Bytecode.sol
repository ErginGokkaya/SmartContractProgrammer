// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Runtime code
// Creation code
// Factory contract

/*
OP code

mstore(p,v)  : store v at memory p to p+32 

PUSH1 x2a // 42 meaning of the universe
PUSH1 0
MSTORE // executes 2 stacks before itself


return (p,s) : end execution and return data from memory p to p+s

PUSH1 0x20
PUSH1 0
RETURN // returns p = 0 and s = 32 bytes 0x20

// Runtime code of above
602a60005260206000f3

// Creation code

PUSH10 0x602a60005260206000f3
PUSH1 0
MSTORE

// because mstore stores 32 bytes creation code stored like:
0x0000000000000000000000602a60005260206000f3 // 22 zeros then 602a60005260206000f3

PUSH1 0x0a // 10 byte
PUSH1 0x16 // from byte 22
RETURN

bytecode of this:
69602a60005260206000f3600052600a6016f3

*/

contract Factory{
    event Log(address addr);
    function deploy() external {
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        address addr;
        // first 32 (0x20) bytes of reference type stores the datalength.. here 38 chars => 19 Bytes => 0x13
        // create(amount of ether to send, memory start address, data size )
        assembly{
            addr := create(0, add(bytecode,0x20), 0x13)
        }
        require(addr != address(0), "Failed");
        emit Log(addr);
    }
}

interface IContract{
    function getMeaningOfLife() external view returns(uint256);
}