// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Data location: storage, memory, calldata

contract DataLocations
{
    struct Sample
    {
        uint256 foo;
        string  text;
    }

    mapping(address => Sample) samples;

    function examples(uint256[] memory y, string memory s) external returns(uint256[] memory)
    {
        y[0] = 321;
        s = "sample";

        samples[msg.sender] = Sample({foo:123, text:"bar"});
        Sample storage sample = samples[msg.sender];
        sample.text = "Storage keeps the changes";

        Sample memory readOnly = samples[msg.sender];
        readOnly.foo = 456; // ignores the changes after brackets

        uint256[] memory memArr = new uint256[](3); // array in memory HAS to be FIXED size
        memArr[0] = 12;
        memArr[1] = 23;
        memArr[2] = 34;

        return memArr;
    }

    function tar(uint256[] calldata _y) private pure returns(uint256)
    {
        uint256 x = _y[0]; // calldata is only read and it is like constant memory.. calldata save gas usage
        return x;
    } 
}

contract SimpleStorage
{
    string private text; // declaration as a state variable needs to be stored in storage

    // function inputs of dynamic types need to be declared with data location
    function setText(string calldata _input) external //function setText(string memory _input) external
    {
        text = _input; // we only read the input here.. so using calldata instead of memory enables us to save the gas
    }

    function getText() external view returns(string memory)
    {
        return text;
    }
}