pragma solidity >=0.7.0 <0.9.0;

contract usingModifiers{

uint public initPeopleCount = 0;
address owner;

modifier onlyOwner(){
    require(msg.sender == owner);
    _;
}
constructor()  {
    owner = msg.sender;
}

mapping(uint => Person) public people;

    struct Person{
        uint _id;
      string  _firstName;
      string _lastName;
    }

    function addPersons(string memory _firstName, string memory _lastName) public{
        peopleCount();
        people[initPeopleCount] = Person(initPeopleCount, _firstName, _lastName);
    }

    function peopleCount()  public{
        initPeopleCount += 1;
    }
}