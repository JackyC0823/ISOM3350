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
    
   
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
///Open the channel for transation
contract PaymentChannel {
  address payable public applicants
  address payable public admin
  uint256 public expiration
  
  constructor(address payable_university, uint256 duration)
    public
    payable
    
  {
    applicants = msg.sender
    admin = _admin
    expiration = now+duration
  }




/// Closing the channel after the transaction
function close(unit token, bytes 32)public(
  require(msg.sender == university);        //validate the action owner is the admin
  require(winner.length > 0);               //validate the winner exists
  require(animal.length > 0);               // valudate the animal exists
  selfdestruct(applicants);                 // delete other applicants
 }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
