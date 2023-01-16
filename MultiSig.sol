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

    constructor(address[] memory _owners, uint256 _required) {
      require(_owners.length > 0);
      require(_required != 0);
      require(_owners.length >= _required);
      owners = _owners;
      required = _required;
    }

    function addTransaction(address _destination, uint256 _value) public returns(uint transactionId) {
      transactionId = transactionCount;
      transactions[transactionCount] = Transaction(_destination, _value, false);
      transactionCount++;
    }
}
