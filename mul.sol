// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KudiWallet{
    //Events
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    //The struct
    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool executed;
    }


    //State Variables
    address[] public owners;
    mapping (address => bool) public isOwner;
    uint public required;
    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approval;

    constructor(address[] memory _owners, uint _required){
        require(_owners.length > 0, "owners required");
        require(
            _required > 0 && _required <= owners.length,
            "Invalid amount of owners"
        );
        for(uint i; i< owners.length; i++){
            address owner = _owners[i];
            require(owner != address(0), "owner is not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }
        required = _required;

    }
    modifier onlyOwner(){
        require(isOwner[msg.sender], "not owner");
        _;
    }
    receive() external payable{
        emit Deposit(msg.sender, msg.value);
    }

    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner{
        transactions.push(Transaction({
            to:_to,
            value:_value,
            data:_data,
            executed:false
        }));
        emit Submit(transactions.length-1);
    }
}