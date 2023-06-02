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

    // Events:
    event NewAuction(
        address indexed creator,
        uint256 indexed identifier,
        string name,
        string description,
        uint256 starTime,
        uint256 endTime,
        uint256 startingPrice
    );

    // (1) A function to create a new auction.
    function createAuction(
        uint256 startsIn,
        uint32 duration,
        string memory name,
        string memory description,
        uint256 startingPrice
    ) external {
        require(
            startsIn >= 30 seconds,
            "It should start in at least 30 seconds!"
        );

        require(
            duration >= 2 minutes,
            "The duration should be at least 120 seconds (2 minutes)!"
        );

        Auction storage newAuction = auctions[id];

        newAuction.startTime = block.timestamp + startsIn;
        newAuction.endTime = block.timestamp + startsIn + duration;
        newAuction.name = name;
        newAuction.description = description;
        newAuction.price = startingPrice;
        newAuction.auctionCreator = msg.sender;

        emit NewAuction(
            msg.sender,
            id,
            name,
            description,
            block.timestamp + startsIn,
            block.timestamp + startsIn + duration,
            startingPrice
        );

        id++;
    }

}