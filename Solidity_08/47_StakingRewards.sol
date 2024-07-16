// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakingRewards{
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;

    address public owner;
    uint256 public duration;
    uint256 public finishAt;
    uint256 public updatedAt;
    uint256 public rewardRate;
    uint256 public rewardPerTokenStored;
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    uint256 public totalSupply;
    mapping (address => uint256) public balannceOf;

    modifier onlyOwner(){
        require(msg.sender == owner,"Unauthorized Access");
        _;
    }

    constructor(address _stakingToken, address _rewardToken){
        stakingToken = IERC20(_stakingToken);
        rewardToken  = IERC20(_rewardToken);

        owner = msg.sender;    
    }

    function setRewardDuration(uint256 _duration) onlyOwner external {
        require(finishAt < block.timestamp, "Duration is not finished");
        duration = _duration;
    }

    function notifyRewardAmount(uint256 _amount) onlyOwner external {
        if(block.timestamp > finishAt){
            rewardRate = _amount / duration;
        }
        else{
            uint256 remainingReward = rewardRate * (finishAt - block.timestamp);
            rewardRate = (remainingReward + _amount) / duration;
        }

        require(rewardRate > 0, "rewardRate = 0");
        require(rewardRate * duration <= rewardToken.balanceOf(address(this)),"Reward is greater than balance");

        finishAt = block.timestamp + duration;
        updatedAt = block.timestamp;
    }

    function stake(uint256 _amount) external {
        require(_amount > 0, "amount = 0");
        stakingToken.transferFrom(msg.sender,address(this),_amount);
        balannceOf[msg.sender] += _amount;
        totalSupply += _amount;
    }

    function withdraw(uint256 _amount) external {
        balannceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    function lastTimeRewardApplicable() public view returns(uint256){
        return (block.timestamp <= finishAt ? block.timestamp : finishAt);
    }

    function rewardPerToken() public view returns(uint256){
        if(totalSupply == 0){
            return rewardPerTokenStored;
        }
        else{
            return rewardPerTokenStored + ( rewardRate * (lastTimeRewardApplicable() - updatedAt) * 1e18 ) / totalSupply;
        }
    }

    function earned(address _account) external view returns(uint256) {
        return balannceOf[_account] * ((rewardPerToken() - userRewardPerTokenPaid[_account]) / 1e18) + rewards[_account];
    }
    function getReward() external {}
}