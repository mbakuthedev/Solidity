pragma solidity >=0.7.0 <0.9.0;

contract first{
   
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
    function kill(Kill _kill) external{
        _kill.kill();
    }
}

contract Kill{
     constructor() payable{}
    function kill() external{
        selfdestruct(payable(msg.sender));

    }
    function getNumbers() external pure returns(uint){
        return 132;
    }
}