// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CrowdFund
{
    event Launch(uint256 indexed CampaignID, address indexed Creator, uint256 Goal, uint32 StartAt, uint32 EndAt);
    event Cancel(uint256 indexed CampaignID);
    event Pledge(uint256 indexed CampaignID,address indexed Pledger, uint256 Amount);
    event Unpledge(uint256 indexed CampaignID,address indexed Pledger, uint256 Amount);
    event Claim(uint256 indexed CampaignID);
    event Refund(uint256 indexed CampaignID,address indexed Caller, uint256 Amount);

    struct Campaign
    {
        address creator;
        uint256 goal;
        uint256 pledged;
        uint32  startAt;
        uint32  endAt;
        bool    claimed;
    }

    IERC20 public immutable token;
    uint256 public count;
    mapping(uint256 => Campaign) public campaigns; // campainID => campain
    mapping(uint256 => mapping(address => uint256)) public pledgedAmount; // campainID => account => pledge amount for campain

    constructor(address _tokenAddress)
    {
        token = IERC20(_tokenAddress);
    }

    function launch(uint256 _goal, uint32 _startAt, uint32 _endAt) external 
    {
        require(_startAt >= block.timestamp,"Cant start in the past");
        require(_endAt > _startAt,"Should end after start");
        require(_endAt <= _startAt + 90 days, "Should be in max duration");

        count += 1;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal   : _goal,
            pledged: 0,
            startAt: _startAt,
            endAt  : _endAt,
            claimed: false
        });

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    function cancel(uint256 _id) external 
    {
        require(_id <= count, "No campain for the id");
        Campaign memory campaign = campaigns[_id];
        require(msg.sender == campaign.creator,"Only creator");
        require(block.timestamp < campaign.startAt,"Started");

        delete campaigns[_id];
        emit Cancel(_id);
    }

    function pledge(uint256 _id, uint256 _amount) external
    {
        require(_id <= count, "No campain for the id");
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt,"Not Started");
        require(block.timestamp <= campaign.endAt  , "Already Ended");

        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }


    function unpledge(uint256 _id, uint256 _amount) external 
    {
        require(_id <= count, "No campain for the id");
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt,"Not Started");
        require(block.timestamp <= campaign.endAt  , "Already Ended");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpledge(_id, msg.sender, _amount);
    }
 
    function claim(uint256 _id) external
    {
        require(_id <= count, "No campain for the id");
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator,"Only Creator");
        require(block.timestamp > campaign.endAt  , "Not Ended");
        require(campaign.pledged >= campaign.goal,"Campaign Not Successful");
        require(!campaign.claimed,"Already Claimed");

        campaign.claimed = true;
        token.transfer(msg.sender, campaign.pledged);

        emit Claim(_id);    
    }

    function refund(uint256 _id) external 
    {
        require(_id <= count, "No campain for the id");
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt  , "Not Ended");
        require(campaign.pledged < campaign.goal,"Campaign Reached The Goal");

        uint256 balance = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, balance);

        emit Refund(_id, msg.sender, balance);
    }
}