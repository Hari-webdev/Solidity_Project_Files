// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Lottery{
    // entities - manager,players and winner

    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor(){
        manager = msg.sender;
    }

    modifier managerMsg() {
         require(manager==msg.sender, "Owner can only view Balance");

        _;
    }

    function participate() public payable{
        require(msg.value == 1 ether, "Please Pay 1 Ether for Entry to the Lotttery Event");
        players.push(payable(msg.sender));

    }

    function getBalance() public view managerMsg returns(uint){
       
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));
    }

   function pickWinner() public managerMsg{
     require(players.length >=3, "Players are less than 3");

     uint r =random();
     uint index = r%players.length;
     winner = players[index];
     winner.transfer(getBalance());
     players=new address payable[](0); // this will intiliaze the players array back to 0;
   
   }






}