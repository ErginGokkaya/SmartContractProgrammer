// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// import "@openzeppelin/contracts/interfaces/IERC721.sol";

interface IERC721
{
    // tip: functions in interfaces must be external 
    function transferFrom(address _from, address _to, uint256 _nftID) external;
}

contract DutchAction
{
    uint256 private constant DURATION = 7 days;

    IERC721 public immutable nft;
    uint256 public immutable nftID;
    uint256 public immutable startsAt;
    uint256 public immutable expiresAt;
    uint256 public immutable discountRate;
    uint256 public immutable startingPrice;
    address payable public immutable seller;

    constructor(uint256 _nftID, address _nft, uint256 _startingPrice, uint256 _discountRate)
    {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;

        require(startingPrice >= discountRate * DURATION, "Price must be higher");

        startsAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
        nft = IERC721(_nft);
        nftID = _nftID;
    }

    function getPrice() public view returns(uint256)
    {
        uint256 timeElapsed = block.timestamp - startsAt;
        uint256 discount    = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    function buy() external payable
    {
        require(block.timestamp < expiresAt, "Action Already Expired");
        uint256 price = getPrice();
        require(msg.value >= price, "More ETH has to be paid");
        nft.transferFrom(seller, msg.sender, nftID);
        uint256 refund = msg.value - price;

        if(refund > 0)
        {
            payable(msg.sender).transfer(refund);
        }
        selfdestruct(seller);
    }
}