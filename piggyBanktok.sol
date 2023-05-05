pragma solidity >=0.7.0 <0.9.0;

contract piggyBank{
    constructor() payable{}
    event Deposit(uint amount);
    event Withdraw(uint amount);
    address public owner = msg.sender;
    
    //This is a callback function called when ether is sent to the contract
    receive () external payable{
        emit Deposit(msg.value);
    }
    function Withdraw(address account) external{
        require(msg.sender == owner, "Not owner");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(account));
    }
}
//Now to create another contract that checks the balance and gets the money sent
contract withdrawalAccount{
    function getBalance() external view returns(uint){
            return address(this).balance;
    }

}
