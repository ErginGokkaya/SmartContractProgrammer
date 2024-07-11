// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Structs
{
    struct Car
    {
        string  model;
        address owner;
    }

    Car public aCar;
    Car[] public cars;
    mapping(address => Car[]) public carsByOwner;

    function examples() external 
    {
        // Ways to initialize the struct
        Car memory whoseCar = Car("Toyota",msg.sender);
        Car memory ofCourseMyCar = Car({owner: msg.sender, model:"Lamborghini"});
        Car memory tesla;
        tesla.model = "Model Y";
        tesla.owner = msg.sender;

        cars.push(whoseCar);
        cars.push(ofCourseMyCar);
        cars.push(tesla);

        cars.push(Car("Ferrari",msg.sender)); // equivallant to initialize in memory

        // get and update
        Car memory _car = cars[0];
        _car.owner; // just reads the owner.. cannot update its value

        Car storage _aCar = cars[1];
        _aCar.model = "TOGG";
        delete _aCar.owner;

        delete cars[2];

    }
}

contract Enums
{
    enum Status
    {
        None,
        Pending,
        Shipped,
        Completed
    }

    Status public status;

    struct Order
    {
        address buyer;
        Status  status;
    }

    Order[] public orders;

    function getStatus() public view returns(Status)
    {
        return status;
    }

    function setStatus(Status state) public
    {
        status = state;
    }
}