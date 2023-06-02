// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

contract AuctionPlatform {
    struct Auction {
        uint256 id;
        uint256 startTime;
        uint256 endTime;
        string name;
        string description;
        uint256 price;
        address auctionCreator;      
        address highestBidder;
    }
     // Storage variables:
    uint256 id = 0; 
    mapping(uint256 => Auction) auctions;

}