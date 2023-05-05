pragma solidity >=0.7.0 <0.9.0;

contract usingMappings{
    uint256 public peopleCount;

    mapping(uint => People) public person;
    struct People {
        uint _id;
        string _firstName;
        string _lastName;
    }
    function addPersons(string memory _firstName, string memory _lastName) public {
        peopleCount += 1;
        person[peopleCount] = People(peopleCount, _firstName, _lastName);
    }
}