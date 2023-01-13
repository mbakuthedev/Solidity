pragma solidity >=0.7.0 <0.9.0;

contract TestContract{
    string public message;
    uint public x;
    constructor() payable{}
    event Log(string message);
    receive() external payable{}
    fallback() external payable{
        emit Log("Fallback Called");

    }
    function foo(string memory _message, uint _x) external payable returns(bool, uint){
        emit Log("Foo called");
        message = _message;
        x = _x;
        return (true, 123);
    }
}

contract TestCall{
    bytes public data;
    constructor() payable{}
    function callFoo(address _test) external payable {
     (bool sucess, bytes memory _data) =  _test.call{value:123}(abi.encodeWithSignature("foo(string, uint256)", "call foo", 123));

        require(sucess, " Call Failed");
         data = _data;
    }
    function callNoFunction(address _test) external payable{
      (bool success, ) = _test.call(abi.encodeWithSignature("doesNotExist()"));
        require(success, "Failed");
    }
}