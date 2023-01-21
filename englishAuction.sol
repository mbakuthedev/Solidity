pragma solidity >=0.7.0 <0.9.0;

interface IERC721{
    function transferFrom(address from, address to, uint nfiId) external;

}

contract EnglishAuction{
    IERC721 public immutable nft;
    uint public immutable nftId;
    address payable public immutable seller;
    uint32 public endAt;
    bool public started;
    bool public ended;
    address public highestBidder;
    uint public highestBid;
    mapping (address => uint) public bids;

    event Start();
    event Withdraw(address indexed bidder, uint amount);
    event End(address highestBidder, uint amount);
    

    constructor(
        address _nft, 
        uint _nftId,
        uint startingBid
    ){
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = startingBid;
    }

    function start() external payable{
        require(msg.sender == seller, "not owner");
        require(!started, "started");

        started = true;
        endAt = uint32(block.timestamp + 120);
        // nft.transferFrom(seller, address(this), nftId);
        emit Start();

    }
      function bid() external payable{
            require(started, "not started");
            require(block.timestamp < endAt, "auction ended");
            require(msg.value > highestBid, "low bid");

            if (highestBidder != address(0)){
                bids[highestBidder] += highestBid;
            }
            highestBid = msg.value;
            highestBidder = msg.sender;

        }
        function withdraw() external payable{
            uint bal = bids[msg.sender];
            bids[msg.sender] = 0;
            payable(msg.sender).transfer(bal);
            emit Withdraw(msg.sender, bal);
        }
        function end() external payable{
            require(started, "auction not started");
            require(!ended, "auction already ended");
            require(block.timestamp >= endAt, "not ended");
            ended = true;
            if(highestBidder != address(0)){
                 nft.transferFrom(address(this), highestBidder, nftId);
                 seller.transfer(highestBid);
            }
            else{
                nft.transferFrom(address(this),seller,nftId);
            }
            emit End(highestBidder, highestBid);
           
        }
}
