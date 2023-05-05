pragma solidity >=0.7.0 <0.9.0;

contract Todolist{
    struct Todo{
        string text;
        bool completed;
        address id;
    }
    Todo[] public todos;
    address owner;
    function Create(string calldata _text) external{
        todos.push(Todo({
            text: _text,
            completed: false,
            id: msg.sender
        }));
    }
//     function update(uint _id, string calldata _text) external{
//         Todo storage todo = todos[_id];
//         todo.text
//    }
  function update(uint _index, string calldata _text) external{
      Todo storage todo = todos[_index];
      todo.text = _text;
      todo.completed = false;
      todo.id = msg.sender;
  }
  function getTodos(uint _index) view external  returns(string memory, address){
      Todo memory todo = todos[_index];
      return (todo.text, todo.id);
  }
  
}