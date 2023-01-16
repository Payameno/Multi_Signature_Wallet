// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MultiSig {
    address[] public owners;
    uint256 public required;
    uint public transactionCount;

    struct Transaction {
      address destination;
      uint256 value;
      bool executed;
    }
    //store transaction with an id untill confirmed by other members
    mapping(uint => Transaction) public transactions;

    //Nested Mapping of confirmations for a transaction
    mapping(uint => mapping(address => bool)) public confirmations;

    constructor(address[] memory _owners, uint256 _required) {
      require(_owners.length > 0);
      require(_required != 0);
      require(_owners.length >= _required);
      owners = _owners;
      required = _required;
    }

    function addTransaction(address _destination, uint256 _value) public returns(uint) {
      transactions[transactionCount] = Transaction(_destination, _value, false);
      transactionCount++;
      return transactionCount - 1;
    }

    function confirmTransaction(uint transactionId) public {
      require(isOwner(msg.sender));
      confirmations[transactionId][msg.sender] = true;
    }

    function getConfirmationsCount(uint transactionId) public view returns(uint) {
      uint count;
      for (uint i = 0; i < owners.length; i++) {
        if (confirmations[transactionId][owners[i]]) {
          count++;
        }
      }
      return count;
    }

    function isOwner(address _addr) public view returns(bool) {
      for (uint i = 0; i < owners.length; i++) {
        if (owners[i] == _addr) {
          return true;
        }
      }
      return false;
    }
}
