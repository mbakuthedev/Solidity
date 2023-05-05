pragma solidity >=0.7.0 <0.9.0;

interface IdeppToken{
     function totalSupply() external view returns(uint);

     function balanceOf(address account) external view returns(uint);

    function transfer(address recipient, uint amount)payable external returns(bool);

     function allowance(address owner, address spender, uint amount) external view returns(uint);

    function approve(address spender, uint amount) external returns(bool);

    function transferFrom(address sender, address recipient, uint amount)payable external returns(bool);

    //Events
    
}

 contract deppToken {

event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount); 
     constructor() payable {

     }
    //State Variables
    uint public  totalSupply;
    mapping(address => uint) public   balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "Johnny Depp";
    string public symbol = "JDP";
    uint public decimals = 18;

     function TotalSupply() external view returns(uint){
         return totalSupply;
     }
     function BalanceOf(address account) external view returns(uint){
         return balanceOf[account];
     }
    //   function Allowance(address owner, address spender, uint amount) external view returns(uint){
    //       return allowance[owner][spender] = amount;

    //   }

    function transfer(address recipient, uint amount) payable external  returns(bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }


    function approve(address spender, uint amount) external  returns(bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) payable external  returns(bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
    function mint(uint amount) external{
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external{
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}