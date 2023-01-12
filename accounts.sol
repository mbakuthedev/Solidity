pragma solidity >=0.7.0 <0.9.0;

contract Account{
    address public bank;
    address public owner;

    constructor(address _owner) payable{
        bank = msg.sender;
        owner = _owner;
    }
    
}
contract AccountFactory{
    Account[] public accounts;
    
    constructor() payable{}
    function createAccount(address _owner) external payable{
        Account account = new Account{value:1400}(_owner);
        accounts.push(account);
    }
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
}