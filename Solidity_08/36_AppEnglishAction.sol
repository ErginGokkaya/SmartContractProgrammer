// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// import "@openzeppelin/contracts/interfaces/IERC721.sol";

interface IERC721
{
    function transferFrom(address _from, address _to, uint256 _nftID) external;
}

contract EnglishAction
{
    IERC721 public immutable nft;
    uint256 public immutable nftId;
    uint256 public endAt;
    bool    public started;
    bool    public ended;
    address payable public immutable seller;
    address public highestBidder;
    uint256 public highetBid;
    mapping(address => uint256) public bids;
    
    event Start();
    event Bid(address indexed bidder, uint256 amount);
    event Withdraw(address indexed receiver, uint256 amount);

    constructor(address _nft, uint256 _nftId, uint256 _startingBid)
    {
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highetBid = _startingBid;
    }

    function start() external 
    {
        require(seller == msg.sender, "Not Seller");
        require(!started, "Only Once");
        started = true;
        endAt = block.timestamp + 7 days;
        nft.transferFrom(seller, address(this), nftId);

        emit Start();
    }

    function bid() external payable 
    {
        require(started, "Not started");
        require(block.timestamp < endAt,"Action Already End");
        require(msg.value > highetBid, "Pay More to Buy");

        if(highestBidder != address(0)) // for first call of bid(), the highestBidder is default address
        {
            bids[highestBidder] += highetBid; // accumlate all the bids for a certain bidder in case he would like to withdraw
        }
        
        highetBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external
    {
        uint256 balance = bids[msg.sender];
        bids[msg.sender] = 0;

        payable(msg.sender).transfer(balance);
        emit Withdraw(msg.sender, balance);
    }

    function end() external 
    {
        require(started,"Not Started");
        require(!ended,"Already Ended");
        require(block.timestamp >= endAt,"Not Ended");

        ended = true;
        if(highestBidder != address(0)) // when transfer something, always consider the address not zero
        {
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highetBid);
        }
        else 
        {
            nft.transferFrom(address(this), seller, nftId);
        }
        
    }
}
