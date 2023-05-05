// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Mbaku.sol";
contract Vault{
    IERC20 public immutable token;
    uint public totalSupply;
    mapping(address => uint) balanceOf;
    constructor(address payable _token)payable{
        token = IERC20(_token);
    }

    function _mint(address _to, uint _amount) private{
        totalSupply += _amount;
        balanceOf[_to] += _amount;
    
    }
    function _burn(address _from, uint _amount) private{
        totalSupply -= _amount;
        balanceOf[_from] -= _amount;
    }
    function deposit(uint _amount) external{
        uint shares;
        //a - amount
        //T - total supply
        //B - balance of token before deposit
        //s - shares to mint
        //s = aT/B
        if(totalSupply == 0){
            shares = _amount;
        }
        else{
            shares = (_amount * totalSupply)/ token.balanceOf(address(this));
        }
        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }
    function destruct(address payable _target) external {
        selfdestruct(_target);
    }
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
}