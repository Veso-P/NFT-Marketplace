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

    constructor(
        string memory _name,
        string memory _symbol,        
        string memory _baseURI,
        uint256 _salesStart,
        uint256 _salesEnd,
        uint256 _ticketPrice
        ) ERC721(_name, _symbol) {
            baseURI = _baseURI;
            salesStart = _salesStart;
            salesEnd = _salesEnd;
            ticketPrice = _ticketPrice;
            transferOwnership(tx.origin);
        }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
}
