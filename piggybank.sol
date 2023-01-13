pragma solidity >=0.7.0 <0.9.0;

contract KudiPiggybank{

constructor() payable{}
    event Deposit(uint amount);
    event Withdraw (uint amount);
    address public owner = msg.sender;
    receive() external payable{
        emit Deposit(msg.value);
    }

    function withdraw(address _account) external {
        require(msg.sender == owner, "not Authorized");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(_account));
    }
}

contract withdrawalAccount{
    function getBalance() external view returns (uint){
        return address(this).balance;
    }
}