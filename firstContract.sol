pragma solidity >=0.7.0 <0.9.0;

contract myContract{
    address public owner;

    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner{
        require(msg.sender == owner , "not owner");
        _;
    }
    function setOwner(address newOwner) view  external onlyOwner{
        require(newOwner != address(0), "invalid address");
        owner == newOwner;
    }
    function onlyOwnerCalls()  external onlyOwner{

    }
    function anyOneCalls()  external {

    }
}