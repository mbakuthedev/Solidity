pragma solidity >=0.7.0 <0.9.0;

contract MyContract{
    function hash(string memory message, uint num, address addr)
     external return(byte32){
         return keccak256(abi.encodePacked(message, num, addr));
     }
}