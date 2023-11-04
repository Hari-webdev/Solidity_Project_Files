// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0 ;

contract EventContract{

    struct Event{
        
    address organizer;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemaining;

    }

    


    mapping(uint => Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string calldata _name, uint _date, uint _price , uint _ticketCount) public{
        require(block.timestamp<_date,"You cannot create an event for past date");
        require(_ticketCount>0,"Ticket count must be greater than 0");
        events[nextId] = Event(msg.sender,_name,_date,_price,_ticketCount,_ticketCount);
        nextId++;
        

    }


    function buyTicket(uint id,uint quantity) public payable{
        require(events[id].date!=0,"No other events is exist");
        require(events[id].date>block.timestamp,"Event has ended");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity),"Ether is not enough");
        require(_event.ticketRemaining>=quantity,"Not Enough Tickets Left");
        _event.ticketRemaining -= quantity;
        tickets[msg.sender][id]+= quantity;


    }


    function transferTicket(uint id, uint quantity, address to) public {
        require(events[id].date!=0,"Event Does Not exist");
        require(events[id].date>block.timestamp,"Event Has Ended");
        require(tickets[msg.sender][id]>=quantity,"you do not have tickets to transfer");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }












}