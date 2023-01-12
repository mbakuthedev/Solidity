pragma solidity >=0.7.0 <0.9.0;

contract myCOntract{
    function hash(string memory message, uint num, address addr) external pure returns(bytes32){
        return keccak256(abi.encodePacked(message,num,addr));
    }
}