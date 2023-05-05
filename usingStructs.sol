pragma solidity >=0.7.0 <0.9.0;
contract usingStructs{
    Persons [] public people;

    uint256 public peopleCount;

    struct Persons{
        string _firstName;
        string _lastName;
    }

    function addPersons(string memory _firstName, string memory _lastName) public {
        people.push(Persons(_firstName, _lastName));
        peopleCount += 1;
    }
}