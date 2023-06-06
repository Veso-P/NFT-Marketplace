// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./Event.sol";

contract MarketPlace {
    uint256 _counter = 0;

    mapping(uint256 => Event) public events;   
    

/// Events:
    event NewCampaign(
        uint256 identifier,
        address creator,
        string name        
    );

    function createEvent(
        string memory _name,
        string memory _symbol,        
        string memory _baseURI,
        uint256 _salesStart,
        uint256 _salesEnd,
        uint256 _ticketPrice
    ) public {
        Event newEvent = new Event(
            _name,
            _symbol,            
            _baseURI,
            _salesStart,
            _salesEnd,
            _ticketPrice            
        );
        events[_counter] = newEvent;

        emit NewCampaign(_counter, msg.sender, _name);

        _counter++;
    }
}