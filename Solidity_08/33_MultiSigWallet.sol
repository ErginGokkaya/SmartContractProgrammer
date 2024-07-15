// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract MultiSigWallet
{
    event Deposit(address indexed sender, uint256 amount);
    event Submit(uint256 indexed txId);
    event Approve(address indexed owner, uint256 indexed txId);
    event Revoke(address indexed sender, uint256 indexed txId);
    event Execute(uint256 indexed txId);

    struct Transaction
    {
        address to;
        uint256 value;
        bytes   data;
        bool    executed;
    }

    modifier onlyOwner()
    {
        require(isOwner[msg.sender],"Not owner");
        _;
    }
    modifier txExists(uint256 _txId)
    {
        require(_txId < transactions.length, "txId not exists");
        _;
    }
    modifier notApproved(uint256 _txId)
    {
        require(!approved[_txId][msg.sender], "Already approved");
        _;
    }
    modifier notExecuted(uint256 _txId)
    {
        require(!transactions[_txId].executed, "Already executed");
        _;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public required; // required number of approvals before execution
    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public approved; // txId => owner => isApproved

    constructor(address[] memory _owners, uint256 _required)
    {
        require(_owners.length > 0, "Invalid owners");
        require(_required <= _owners.length,"Too many approvals");

        uint256 numOfOwners = _owners.length;

        for(uint256 i = 0; i < numOfOwners;)
        {
            address currentOwner = _owners[i];
            require(currentOwner != address(0), "Invalid user");
            require(!isOwner[currentOwner],"Already owner");

            isOwner[currentOwner] = true;
            owners.push(currentOwner);

            unchecked{i++;}
        }

        required = _required;
    }

    receive() external payable 
    {
        emit Deposit(msg.sender, msg.value);
    }

    function submit(address _to, uint256 _amount, bytes calldata _data) external onlyOwner
    {
        transactions.push(Transaction({
            to: _to,
            value: _amount,
            data: _data,
            executed: false
        }));

        emit Submit(transactions.length -1);
    }

    function approve(uint256 txId)
            external
            onlyOwner
            txExists(txId)
            notApproved(txId)
            notExecuted(txId)
    {
        approved[txId][msg.sender] = true;
        emit Approve(msg.sender, txId);
    }

    function getApprovalCount(uint256 _txId) private view returns(uint)
    {
        uint256 count = 0;
        uint256 numOfOwners = owners.length;

        for(uint256 i = 0; i < numOfOwners;)
        {
            count += approved[_txId][owners[i]] ? 1 : 0; 
            unchecked{i++;}
        }

        return count;
    }

    function execute(uint256 txId) external txExists(txId) notExecuted(txId)
    {
        require(getApprovalCount(txId) >= required, "Not enough approvals");
        Transaction storage transaction = transactions[txId];

        transaction.executed = true;
        (bool success,) = transaction.to.call{value: transaction.value}(transaction.data);

        require(success, "Execution failed");
        emit Execute(txId);
    }

    function revoke(uint256 _txId) external onlyOwner txExists(_txId) notExecuted(_txId)
    {
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }

}