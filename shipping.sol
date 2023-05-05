pragma solidity >=0.7.0 <0.9.0;

contract shipping{
    enum ShippingStatus{
        None,
        Pending,
        Waiting,
        Shipped, 
        Completed,
        Rejected
    }
    ShippingStatus public status;
    struct Order{
        address buyer;
        ShippingStatus status;
    }
    Order[] public orders;
    function shipped() internal{
        status  = ShippingStatus.Shipped;
    }
    
}