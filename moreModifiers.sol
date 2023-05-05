pragma solidity >=0.7.0 <0.9.0;

contract moreModifiers{
    
bool public paused;
uint public count;

function setPause(bool _paused)  external{
    paused = _paused;
}
modifier WhenNotPaused(){
    require(!paused, "paused");
    _;
}
function increment() external WhenNotPaused{
    count++;
}
}