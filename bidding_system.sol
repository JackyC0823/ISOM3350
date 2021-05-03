// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
//This code for adoption bidding in our system

contract AdoptionBidding {
    //The solidity is to show how an adopter can win the bid
    address payable public TheOrganization; // address of the organization
    uint public ExpiredTime; //Auction expired
    uint public RevealTime; //Reveal the highest bid
    bool public expired; //check whether the auction expired
    
    //All bid will be stored in form of hashed bid and token amount
    struct TokenBid{
        bytes32 HashedBid;
        uint Token;
    }
    
    mapping(address => TokenBid[]) public bids;
    
    //Current state of bidding
    address public highestBidder;
    uint public highestBid;

    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingRefund;

    event AuctionEnded(address winner, uint highestBid);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}