pragma solidity >=0.7.0 <0.9.0;

contract Testtoken{
    constructor () payable{

    }
    //State VAriables
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint )) public allowance;
    string public name = "Test Token";
    string public symbol = "TTK";
    uint public decimals = 18;

    function TotalSupply() external view returns (uint){
        return totalSupply;
    }
    function BalanceOf(address account) external view returns(uint){
        return balanceOf[account];
    }
    function Approve(address spender, uint amount) external  returns(bool){
      allowance[msg.sender][spender] = amount;
        return true;

    }
    function Transfer(address recipient, uint amount)payable external  returns(bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        return true;
    }
    function approve(address spender, uint amount) external returns (bool){
        allowance[msg.sender][spender] = amount;
        return true;
    }
    function transferFrom(address sender, address recipient, uint amount) payable external returns(bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        return true;
    }

    function burn(uint amount) external{
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

    }
    function mint(uint amount ) external{
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
    }
}
