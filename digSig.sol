pragma solidity >=0.7.0 <0.9.0;

contract digitalSignature{
    function verifySig(address signer, string memory message, bytes memory sig)
    external pure returns (bool){
        bytes32 messageHash = getMessageHash(message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        return recover(ethSignedMessageHash, sig) == signer;
    }

    function getMessageHash(string memory message)
     public pure returns(bytes32){
         return keccak256(abi.encodePacked(message));
     }

     function getEthSignedMessageHash(bytes32 messageHash)
     public pure returns(bytes32){
         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash));
     }
     function recover(bytes32 ethSignedMessageHash, bytes memory sig)
     public pure returns(address){
         (bytes32 r, bytes32 s, uint8 v) = _split(sig);
         return ecrecover(ethSignedMessageHash,v,r,s);
     }
     function _split(bytes memory sig)
     internal pure returns(bytes32 r, bytes32 s, uint8 v){
         require(sig.length == 65, "invalid signature length");
         assembly{
             r:=mload(add(sig,32))
             s:=mload(add(sig,64))
             v:=byte(0,mload(add(sig,96)))
         }
     }
}