pragma solidity >=0.7.0 <0.9.0;

interface IERC721{
    function transferFrom(address _from, address _to, uint _nftId) external;

}

contract carDutchAuction{
    uint private constant duration = 7 days;
    IERC721 public immutable nft;
    uint public immutable nftId;
    address payable public immutable seller;
    uint  public startingPrice;
    uint immutable public startAt;
    uint immutable public endsAt;
    uint  public  discountRate;

    constructor( 
        uint _startingPrice,
        uint _discountRate,
        address _nft,
        uint _nftId
    )  {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        endsAt = block.timestamp + duration;

        require(_startingPrice >= discountRate * duration, "Starting price is too low");
        nftId = _nftId;
        nft = IERC721(_nft);
    }
    function getPrice() external view returns(uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    function buy() payable external{
        require(block.timestamp < endsAt, "auction expired");
        uint price = (this).getPrice();
        require(msg.value >= price, "");
        nft.transferFrom(seller, payable(msg.sender), nftId);
        uint refund = msg.value - price;
        if (refund > 0){
            payable(msg.sender).transfer(refund); 
        }
        selfdestruct(seller);
    }
   
}