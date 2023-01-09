pragma solidity >=0.7.0 <0.9.0;

contract carModelling{
    struct Car{
        address owner;
        string model;
        uint year;
    }
    Car public car;
    Car[] public cars;
    mapping(address => Car) public carsByOwners;
    // function createCar() external {
    //     Car memory toyota = Car(msg.sender, "toyota", 1732);
    // }
    function createCars(string calldata _model, uint calldata _year)  external{
        cars[msg.sender] = Car({
             model :_model,
             year : _year
        }) ; 
        cars.push(Car);
    }
}