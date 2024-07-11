// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract IterableMapping // we need this because we dont have something we have for arrays to iterate
{
    mapping(address => uint256) public balances;
    mapping(address => bool)    public inserted; // need this because solidity behaves same for account having 0 balance and account not existing
    address[] public accountAddresses;

    function setBalance(address _accountAddress, uint256 _amount) external 
    {
        balances[_accountAddress] += _amount;

        if(!inserted[_accountAddress])
        {
            inserted[_accountAddress] = true;
            accountAddresses.push(_accountAddress);
        }
    }
}


contract Mappings
{
    mapping(string => bool) public whitelist;

    function setWhite(string memory _name) external
    {
        whitelist[_name] = true;
    }
}


contract ArrayShift
{
    uint256[] public arr;

    function examples() external
    {
        arr = [1,2,3,4,5];
        delete arr[2]; // [1,2,0,4,5]
    }

    function remove(uint256 _index) external
    {
        uint256 length = arr.length;
        require(_index < length, "Index Out Of Bound");
        
        for(uint256 i = _index; i < length-1; )
        {
            arr[i] = arr[i+1];
            unchecked{i++;}
        }

        arr.pop();
    }

    function removeAndReplace(uint256 _index) external
    {
        require(_index < arr.length, "Index OutOfBound");
        arr[_index] = arr[arr.length-1];
        arr.pop();
    }
}


contract Arrays
{
    uint256[]  public nums; // dynamic size array
    uint256[3] public numsFixed; // fixed size array
    uint256[]  public _arr = [1,2,3]; // initialization

    function examples() external
    {
        nums.push(1);
        nums.push(2);
        nums.push(3);

        nums[2] = 5; // element access and update
        delete nums[1]; // changes the value of element at index 1 to default value 0.. not shrinks the length
        nums.pop(); // pops the last element and shrinks the length--;

        uint256[] memory sampleArr = new uint256[](12); // arrays declared in memory have to be fixed size
        //sampleArr.push(12);
        //sampleArr.pop(); these cannot be called
        sampleArr[2] = 17;
        sampleArr.length; 
    }

    function returnArray() external view returns(uint256[] memory)
    {
        return nums; // returning array from functions is possible but not recommneded in terms of gas usage
    }

    function addElement(uint256 _value) external returns(uint256)
    {
        nums.push(_value);
        return nums.length;
    }
}