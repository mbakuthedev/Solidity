pragma solidity >=0.7.0 <0.9.0;

contract Kudiwallet{
    //This wallet only allows the account that deploys the smart contract to be able to withdraw
address payable public owner;

    constructor(){
        msg.sender == owner;
    }
    modifier requireOwner() {
        require(msg.sender == owner, "Not owner!");
        _;
    }
    function withdraw(uint _amount) external payable requireOwner{
       payable (msg.sender).transfer(_amount);
    }
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
}