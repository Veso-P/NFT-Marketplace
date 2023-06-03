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
    mapping(address => uint256) availableToWithdrawal;

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

     event NewHighestBid(        
        uint256 indexed identifier,
        address previousHighestBidder,
        address newHighestBidder,
        uint256 bid
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

    // (2) A function used to place a bid on an auction.
    function placeBid(uint256 auctionId)
        external
        payable
        onlyActiveAuction(auctionId)
    {
        require(msg.sender != auctions[auctionId].auctionCreator, "No bids on your own auction!");
        require(msg.sender != auctions[auctionId].highestBidder, "You have already placed the highest bid!");
        uint256 bid = msg.value;
        require(
            bid > auctions[auctionId].price,
            "Place a bid higher than the current one!"
        );

        address previousHighestBidder = auctions[auctionId].highestBidder;
        uint256 prevousHighestBid = auctions[auctionId].price;

        availableToWithdrawal[previousHighestBidder] += prevousHighestBid;
        auctions[auctionId].price = bid; // The new higehst bid for the auction.         
        auctions[auctionId].highestBidder = msg.sender; // The new highest bidder for the auction.

        emit NewHighestBid (auctionId, previousHighestBidder, auctions[auctionId].highestBidder, bid );
    
    }

    // (3) A function used to finalize the auction that can be called by anyone.
    function finalizeAuction (uint256 auctionId) external payable {
        
        require(
            block.timestamp > auctions[auctionId].endTime,
            "The auction has still not ended!"
        );

        if (auctions[auctionId].price > 0) {
            payable(auctions[auctionId].auctionCreator).transfer(
                auctions[auctionId].price
            );
        }

        delete auctions[auctionId];
    }

    // (4) A function for users to withdraw their available funds.
    function withdraw () public {
        require(availableToWithdrawal[msg.sender] >0, "There is no money available to withdraw!");
        uint availableToWithdraw = availableToWithdrawal[msg.sender];
        availableToWithdrawal[msg.sender] = 0;
        payable(msg.sender).transfer(availableToWithdraw);        
    }

    // MODIFIERS
    // (5) A modifier used to check if the auction is active. 
    modifier onlyActiveAuction (uint256 index) {
        require(
            block.timestamp >= auctions[index].startTime,
            "The auction has not started!"
        );

        require(
            block.timestamp <= auctions[index].endTime,
            "The auction has finished!"
        );
       
        _;
    }

}