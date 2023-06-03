# Solidity
Learning Solidity by writing simple contracts.

# A Decentralized Auction Platform
A decentralized auction platform that allows users to create, bid on, and finalize auctions for various items. Users are able to participate in multiple auctions simultaneously and retrieve their funds if they are outbid or if an auction ends without their bid being the highest.

## Functionality
The "AuctionPlatform" contract has the following functionalities:

1. createAuction: A function to create a new auction with a unique identifier, start time, duration, and item details (name, description, and starting price). It emits the appropriate event for auction creation.
2. placeBid: A function to place a bid on an auction, which check if the bid is higher than the current highest bid for the specified auction. It emits the appropriate event for bid placement.
3. finalizeAuction: A function to finalize the auction that can be called by anyone. This function checks if the auction has ended, and if so, it transfers the winning bid amount to the auction's creator and set the auction as finalized. It transfers the winning bid amount to the creator only in case it is bigger than 0.
4. withdraw: A function for users to withdraw their available funds when they have been outbid or when the auction has ended without their bid being the highest.
5. onlyActiveAuction: A custom modifier to check if the auction is still active.