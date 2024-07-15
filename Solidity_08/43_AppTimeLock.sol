// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// commonly used for delay transactions
contract TimeLock
{
    error NotInRange(uint256 BlockTimeStamp, uint256 InputTimestamp);
    event Queue(bytes32 indexed txId, address indexed target, uint256 value, string func, bytes data, uint256 timestamp);
    event Execute(bytes32 indexed txId, address indexed target, uint256 value, string func, bytes data, uint256 timestamp);
    event Receive(address indexed sender, uint256 value);

    uint256 private constant MIN_DELAY    = 10;
    uint256 private constant MAX_DELAY    = 1000; //in sec
    uint256 private constant GRACE_PERIOD = 100;

    address public immutable owner;
    mapping(bytes32 => bool) public queued;
    constructor()
    {
        owner = msg.sender;
    }

    receive() external payable 
    {
        emit Receive(msg.sender,msg.value);
    }

    modifier onlyOwner()
    {
        require(owner == msg.sender,"Unauthorized Access");
        _;
    }

    // transactions are queued by:
    function queue(address _target, uint256 _value, string calldata _func, bytes calldata _data, uint256 _timestamp)
                   external onlyOwner 
    {
        // create tx id
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        // check tx id is unique
        require(queued[txId],"Tx is not unique");
        // check timestamp
        if(_timestamp < block.timestamp + MIN_DELAY ||
           _timestamp > block.timestamp + MAX_DELAY)
        {
            revert NotInRange(block.timestamp, _timestamp);
        }
        // queue the tx
        queued[txId] = true;

        emit Queue(txId, _target, _value, _func, _data, _timestamp);
    }
    function execute(address _target, uint256 _value, string calldata _func, bytes calldata _data, uint256 _timestamp) 
                     external payable onlyOwner returns(bytes memory)
    {
        // create tx id
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        // check tx id queued
        require(queued[txId],"Not Queued");
        // check timestamp
        require(block.timestamp > _timestamp, "Timestamp Not Passed");
        require(block.timestamp < _timestamp + GRACE_PERIOD, "Timestamp Expired");
        
        queued[txId] = false;
        bytes memory data;
        if(bytes(_func).length > 0 )
        {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))),_data);
        }
        else 
        {
            data = _data;
        }
        (bool success, bytes memory result) = _target.call{value: _value}(data);
        require(success, "Failed");

        emit Execute(txId, _target, _value, _func, _data, _timestamp);
        return result;
    }

    function cancel(bytes32 txId) external onlyOwner
    {
        require(queued[txId],"Not Queued");

        queued[txId] = false;
    }

    function getTxId(address _target, uint256 _value, string calldata _func, bytes calldata _data, uint256 _timestamp)
                    public pure returns(bytes32)
    {
        return keccak256(abi.encode(_target,_value,_func,_data,_timestamp));
    }
}

contract TestTimeLock
{
    address public timeLock;

    constructor(address _timeLock)
    {
        timeLock = _timeLock;
    }

    function test() external view
    {
        require(msg.sender == timeLock, "Not the contract");
        
    }
}
