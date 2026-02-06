// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IMultiSig.sol";

contract MultiSigWallet is IMultiSig {
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public numConfirmationsRequired;

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 numConfirmations;
    }

    mapping(uint256 => mapping(address => bool)) public isConfirmed;
    Transaction[] public transactions;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid requirement");

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            isOwner[owner] = true;
            owners.push(owner);
        }
        numConfirmationsRequired = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submitTransaction(address _to, uint256 _value, bytes memory _data) public onlyOwner {
        uint256 txIndex = transactions.length;
        transactions.push(Transaction({to: _to, value: _value, data: _data, executed: false, numConfirmations: 0}));
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    function confirmTransaction(uint256 _txIndex) public onlyOwner {
        require(!isConfirmed[_txIndex][msg.sender], "Already confirmed");
        transactions[_txIndex].numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;
        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    function executeTransaction(uint256 _txIndex) public onlyOwner {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.numConfirmations >= numConfirmationsRequired, "Not enough approvals");
        require(!transaction.executed, "Already executed");

        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "TX failed");

        emit ExecuteTransaction(msg.sender, _txIndex);
    }
}
