// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
1. message to sign
2. hash(message)
3. sign(hash(message), private key) | offchain
4. ecrecover(hash(message), signature) == signer
*/

contract VerifySignature
{
    function verify(address _signer, string memory _message, bytes memory _signature) external pure returns(bool)
    {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recover(ethSignedMessageHash, _signature) == _signer;

    }

    function getMessageHash(string memory _message) private pure returns(bytes32)
    {
        return keccak256(abi.encode(_message));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) private pure returns(bytes32)
    {
        return keccak256(
            abi.encode(
                "\x19Ethereum Signed Message:\n32",
                _messageHash
            ));
    }

    function recover(bytes32 _signedMessageHash, bytes memory _sig) private pure returns(address)
    {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
        return ecrecover(_signedMessageHash,v,s,r);
    }

    function _split(bytes memory _sig) private pure returns(bytes32 r, bytes32 s, uint8 v)
    {
        require(_sig.length == 65,"Invalid Signature"); // r:32 bytes, s:32 bytes and v: 1byte
        assembly
        {
            // dynamic datatype's first 32 bytes gives the length of the data
            // _sig is not the signature but a pointer to the signature
            r := mload(add(_sig,32)) // skip first 32 bytes to reach the r
            s := mload(add(_sig,64)) // skip first 32 for length and 32 for r to reach the s
            v := byte(0,mload(add(_sig,96))) // get the first byte at index 0 after skipping 96 bytes
        }
    }
}