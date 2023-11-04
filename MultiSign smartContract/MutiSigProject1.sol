// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract MultiSig { 

      address[] public owners; // Array of address is used for multi owners adding in single wallet.
      uint public numConfirmationsRequired;

      struct Transaction{
        address to;
        uint value;
        bool executed;
      }

      Transaction[] public transaction;

      event TransactionSubmitted(uint transactionId, address sender, address receiver,uint amount);
      event TransactionConfirmed(uint transactionId);
      event TransactionExecuted(uint transactionId);

      mapping(uint=>mapping(address => bool)) isConfirmed;

      constructor(address[] memory _owners, uint _numConfirmationsRequied){
        require(_owners.length>1,"Owners must be greater than One");
        require(_numConfirmationsRequied>0&& _numConfirmationsRequied<=_owners.length);

         for(uint i=0; i<_owners.length; i++){
            require(_owners[i]!=address(0),"Invalid Owner");
            owners.push(_owners[i]);

         }

         numConfirmationsRequired = _numConfirmationsRequied;




      }

      function submitTransaction(address _to) public payable{
        require(_to!=address(0),"Invalid Receiver address");
        require(msg.value>0,"Transfer amount must be greater than Zero");
        uint transactionId = transaction.length;
        transaction.push(Transaction({to: _to, value:msg.value,executed:false}));  // Bard
        emit TransactionSubmitted(transactionId, msg.sender,_to,msg.value);
      }

      function confirmTransaction(uint _transactionId) public{
        require(_transactionId<transaction.length,"Invalid transaction Id");
        require(!isConfirmed[_transactionId][msg.sender],"transaction Is Already Confirmed By the owner");//bard
        isConfirmed[_transactionId][msg.sender]=true;
        emit TransactionConfirmed(_transactionId); 
        if(isTransactionConfirmed(_transactionId)){
          executeTransaction(_transactionId);
        }
      }

      function executeTransaction(uint _transactionId) public  payable{ 

        require(_transactionId<transaction.length,"Invalid Transaction Id");
        require(!transaction[_transactionId].executed,"Transaction is already executed");
        
        ( bool success, ) = transaction[_transactionId].to.call{value:transaction[_transactionId].value}("");
        transaction[_transactionId].executed = true;
        require(success,"Transaction Executeion Failed"); 
        emit TransactionExecuted(_transactionId);




         
         
      }

      function isTransactionConfirmed(uint _transactionId) public view returns(bool){
        require(_transactionId<transaction.length,"invalid Transaction Id"); 
        uint confimationCount;

        for(uint i=0; i<owners.length; i++){
          if(isConfirmed[_transactionId][owners[i]]){
            confimationCount++;
          }
        }
        return (confimationCount >= numConfirmationsRequired);
      }

       
 






}