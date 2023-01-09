pragma solidity >=0.7.0 <0.9.0;

contract usingEvents{
    // event log(string indexed message, uint indexed id);
    // string[] public messages;
    // function Message(string memory Msg, uint calldata _id) external{
    //     messages.push(Msg);
    //     _id++;
    //     emit log(messages, _id);
    // }
    event Message(address indexed from, address indexed to, string Message);

    function sendMessage(address _to, string calldata message) external{
        emit Message(msg.sender, _to, message);
    }
}