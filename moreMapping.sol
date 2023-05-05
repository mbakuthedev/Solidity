pragma solidity >=0.7.0 <0.9.0;

contract MyContract{
    mapping (address=> uint) public balances;
    mapping(address => bool) public inserted;
    address[] public keys;
    address owner;

    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "not owner!");
        _;
    }
    function set(address  _key, uint value) external onlyOwner{
        balances[_key] = value;
        if(!inserted[_key]){
            inserted[_key] = true;
            keys.push(_key);
        }
    }
    function getSize() external view returns(uint){
        return keys.length;
    }
    function first() external view returns(uint){
        return balances[keys[0]];
    }
    function last()external view returns(uint){
        return balances[keys[keys.length - 1]];
    }
    function get(uint id ) external view returns (uint){
        return balances[keys[id]];
    }


}