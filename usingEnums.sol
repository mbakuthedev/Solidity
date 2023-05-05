pragma solidity >=0.7.0 <0.9.0;

contract myContract{
    enum State{
    Active,
    Waiting,
    Inactive
}
State public  state;
constructor() {
    state = State.Waiting;
}
function Activate() public{
    state = State.Active;
}
function IsActive() public view returns(bool) {
    return state == State.Active;
}
}