pragma solidity >=0.7.0 <0.9.0;

contract KudiJointWallet{
    event Deposit(address indexed sender, uint amount);
    event Submit (uint indexed txId);
    event Approve(address indexed owner, uint txId);
    event Revoke(address indexed owner, uint txId);
    event Execute(uint txId);

    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    //state variables

    Transaction[] public transactions;
    mapping (address => bool) public isOwner;
    uint public required;
    address[] public owners;
    mapping (uint => mapping (address => bool)) public approved;

    constructor(address[] memory _owners, uint _required){
    require(_owners.length > 0, "owners required!");
    require(_required > 0 && _required <= _owners.length, "invalid required number of owners");
        for(uint i; i < _owners.length; i++){
            address owner = _owners[i];
            require(owner != address(0), "invalid address");
            require(!isOwner[owner], "owner is not unique");
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
            data : _data,
            executed: false
        }));
        emit Submit(transactions.length - 1);
    }
}