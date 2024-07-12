// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract ToDoList
{
    struct ToDo
    {
        string name;
        bool completed;  
    }

    ToDo[] public todos;
    
    function create(string calldata _input) external
    {
        todos.push(ToDo({name: _input, completed: false}));
    }

    function update(uint256 _index, string calldata _name) external 
    {
        require(_index < todos.length);
        todos[_index].name = _name;
        
        // alternative: if there are multiple fields to update below is cheaper in terms of GAS 
        // ToDo storage currentTodo = todos[_index];
        // currentTodo.name = _name;
    }

    function get(uint256 _index) external view returns(string memory, bool) 
    {
        require(_index < todos.length);
        ToDo memory todo = todos[_index];
        return (todo.name,todo.completed);
    }
}