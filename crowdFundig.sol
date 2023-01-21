pragma solidity >=0.7.0 <0.9.0;

contract kudiCrowdFunding{
    struct Campaign{
        address creator;
        uint goal;
        uint pledged;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
        
    }
    //Events
    
    IERC20 public immutable token;
    uint public count;
    mapping (uint => Campaign) public campaigns;
    mapping (uint => mapping(address => uint)) public pledgedAmount;

    constructor(address _token){
        token = IERC20(_token);
    }

    function Launch(uint _goal, uint32 _startAt, uint32 _endAt) external{
        require(_startAt >= block.timestamp, "can't start at such time");
        require(_endAt >= _startAt, "ending time greater");
        require (_endAt <= block.timestamp + 90 days, "");

        count += 1;
        Campaign[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged : 0,
            startAt: _startAt,
            endAt : _endAt,
            claimed: false
        });
        emit launch(count, msg.sender, _goal, _startAt, _endAt);
    }
    function Cancel(uint _id) external{
        Campaign memory campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "You're not the creator");
        require(block.timestamp  < campaign.startAt, "Campaign started");

        delete campaign[_id];
        emit cancel(_id);

    }
    function pledge(uint _id, uint _amount) external{
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.startAt, "not started");
        require(block.timestamp <= campaign.endAt, "ended");

        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);
        emit pledge(_id, msg.sender, _amount);
    }
    function Unpledge(uint _id, uint _amount) external{
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.startAt, "not started");
        require(block.timestamp <= campaign.endAt, "ended");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
        emit unpledge(_id, msg.sender, _amount);
    }

    function Claim(uint _id) external{
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not owner");
        require (block.timestamp > campaign.endAt, "campaign has not ended");
        require(campaign.pledged >= campaign.goal, "goal not reached");
        require(!campaign.claimed, "claimed");

        campaign.claimed = true;
        token.transfer(msg.sender, campaign.pledged);
        emit claim(_id);
    }

    function refund(uint _id) external{
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "campaign has not ended");
        require(campaign.pledged < campaign.goal, "pledge less than goal");

        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);
        emit refund(_id, msg.sender, bal);
    }

}

