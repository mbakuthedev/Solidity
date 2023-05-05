pragma solidity >=0.7.0 <0.9.0;

contract Timelock{
    //Errors
    error NotOwnerError();
    error AlreadyQueuedError(bytes32 txId);
    error TimeStampNotInRangeError();
    error NotQueuedError(bytes32 txId);
    error TImestampElapsedError(uint timestamp, uint expiresAt);
    error TxFailedError();

    //eEvents
    event Execute(
        bytes32 indexed txId,
         address indexed target,
         uint _value, 
         string func,
         bytes data,
         uint timestamp
           );

    event Queue(
        bytes32 indexed txId,
         address indexed target,
          uint _value, string func,
           bytes data, uint timestamp
           );

    event Cancel(bytes32 txId);
    
    //State variables
    address public owner;
    mapping(bytes32 => bool) public queued;

    //Constants 
    uint public constant MIN_DELAY = 10;
    uint public constant MAX_DELAY = 1000;
    uint public constant GRACE_PERIOD = 1000;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        if(msg.sender != owner){
            revert NotOwnerError();
        }
        _;
    }

    function getTxId(
        address _target, 
        uint _value ,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
         ) public pure returns(bytes32 txId){
             return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
         }

    function queue(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
        ) external onlyOwner{
            bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
            if(queued[txId]){
                revert AlreadyQueuedError(txId);
            }
            if (_timestamp < block.timestamp + MIN_DELAY || _timestamp > block.timestamp + MAX_DELAY){
                revert TimeStampNotInRangeError();
            } 
            queued[txId] = true;
            emit Queue(txId, _target, _value, _func, _data,_timestamp );
        }
        function execute(
            address _target,
            uint _value,
            string calldata _func, 
            bytes calldata _data, 
            uint _timestamp
            ) external payable onlyOwner returns(bytes memory)
            {
                bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
                if(!queued[txId]){
                    revert NotQueuedError(txId);
                }
                if (block.timestamp < _timestamp + GRACE_PERIOD){
                    revert TImestampElapsedError(block.timestamp, _timestamp + GRACE_PERIOD);
                }
                queued[txId] = false;
                //Prepare the data
                bytes memory data;
                if(bytes(_func).length > 0){
                    data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
                }else{
                    data = _data;
                }
                (bool ok, bytes memory response) =_target.call{value: _value}(data);
                if(!ok){
                    revert TxFailedError();
                }
                return response;
               emit Execute(txId, _target, _value, _func, _data,_timestamp );
            }

            function cancel(bytes32 _txId) external onlyOwner{
                if(!queued[_txId]){
                    revert NotQueuedError(_txId);
                }
                queued[_txId] = false;
                emit Cancel(_txId);
            }
}

contract TestTimelock{
    address public timelock;

    constructor(address _timelock){
           timelock = _timelock;
    }
     
     function Test() external returns(uint){
         require(msg.sender == timelock, "not owner");
        return block.timestamp + 100;
     }
     function getTimestamp() external view returns(uint){
         return block.timestamp + 100;
     }
    


}