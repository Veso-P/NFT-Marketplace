// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Event is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public salesStart;
    uint256 public salesEnd;
    uint256 public ticketPrice;
    string baseURI;

    uint16 maxTickets = 100;
    uint256 profit;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI,
        uint256 _salesStartIn,
        uint256 _salesEndIn,
        uint256 _ticketPrice
    ) ERC721(_name, _symbol) {
        baseURI = _baseURI;
        salesStart = _salesStartIn + block.timestamp;
        salesEnd = _salesEndIn + block.timestamp;
        ticketPrice = _ticketPrice;
        transferOwnership(tx.origin);
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function buyTicket() public payable isActive {
        require(_tokenIdCounter.current() < maxTickets, "All tickets are sold!");
        require(msg.value == ticketPrice, "Send the correct amount of money!");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        profit += ticketPrice;
    }

    function getProfit() public onlyOwner notActive returns (bool success) {
        uint256 fundsToSend = profit;
        profit = 0;
        (bool sent, ) = payable(owner()).call{value: fundsToSend}("");
        return sent;
    }

    /// Modifiers:
    
    /// A modifier to check if the campaign is still active
    modifier isActive {
        require(block.timestamp < salesEnd, "Ticket sale ended!");
        _;
    }

    /// A modifier to check if the campaign is not active
    modifier notActive {
        require(block.timestamp >= salesEnd, "Ticket sale is still active!");
        _;
    }
}
