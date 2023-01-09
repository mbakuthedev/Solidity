pragma solidity >=0.7.0 <0.9.0;

contract sendEther{


    receive() external payable{}

    function sendViaTransfer(address payable _to, uint  _amount) external payable{
        _to.transfer(_amount);
    }
    function sendViaSend(address payable _to, uint _amount) external payable{
       bool sent =  _to.send(_amount);
       require(sent, "Failed");
    }

    // function sendViaCall(address payable _to, uint _amount) external payable{
    //    (bool sucess, ) =  _to.call({
    //         value:_amount

    //     });
    }

    contract EthReciever{
        event Log(uint amount, uint gas);

        receive() external payable{
            emit Log(msg.value, gasleft());
        }
    }
