// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MultiSig{   

    //person1 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    //person2 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    //person3 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db 

    // Receiver person = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;

    // ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]
    event Deposit(address indexed sender, uint amount);
    event  Submit(uint indexed txId);
    event Approval (address indexed  owner, uint indexed txId);
    event Revoke (address indexed owner, uint indexed  txId);
    event Execute(uint indexed txId);

     struct Transaction{
        address to;
        uint value;
        bool executed;
     }

     function submit(address _to ,uint _value) external OnlyOwner{
        transaction.push(Transaction({
            to: _to,
            value: _value,
            executed:false
        }));

        emit Submit(transaction.length -1);
       }
  
   address[] public owners;

   Transaction[] public transaction; 

   mapping(address => bool) public isOwner;
   mapping(uint => mapping(address => bool)) public approved;

   uint public required;  


    modifier OnlyOwner(){
        require(isOwner[msg.sender],"You are not owner");
        _;
    } 

    modifier txExists(uint _txId){
        require(_txId < transaction.length,"tx does not exist");
        _;
    }

    modifier notApproved(uint _txId){
        require(approved[_txId][msg.sender],"tx already approved");
        _;
    }

    modifier notExecuted(uint _txId){
        require(!transaction[_txId].executed,"tx already executed");
        _;
    }



   constructor(address[] memory _owners, uint _required){
       required = _required; 
       require(_owners.length > 0 , "Owner required");
       require(_required > 0 && _required <=_owners.length,"Invalid required");

       for(uint i; i < _owners.length; i++){
        address owner = _owners[i];
        require(owner != address(0), "Invalid owner");
        require(!isOwner[owner], "Owner is not unique"); // !Falase = True  ;
        isOwner[owner] = true;  // False = True ;
        owners.push(owner);

       } 
        
          

   } 

     receive() external payable { 
        emit Deposit(msg.sender,msg.value);
     }


       

       function approve(uint _txId) external OnlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId){
        approved[_txId][msg.sender] = true;
        emit Approval(msg.sender, _txId);

       }

       function getApprovalCount(uint _txId) private view returns(uint count){
           for(uint i ; i < owners.length; i++){
            if(approved[_txId][owners[i]]){
                count +=1;
            }
           }
       } 

       function execute(uint _txId) external OnlyOwner txExists(_txId) notExecuted(_txId) {
        require(getApprovalCount(_txId) >= required, "Approval less than required");
        Transaction memory transactionOne = transaction[_txId]; // Dout
        transactionOne.executed = true;
        (bool sucess,) = transactionOne.to.call{value:transactionOne.value}(""); // Dout
        require(sucess, "tx Failed"); // Dout
       }
        

        function revoke( uint _txId) external OnlyOwner txExists(_txId) notExecuted(_txId){
            require(approved[_txId][msg.sender], "tx not approved");
            approved[_txId][msg.sender] = false;
            emit Revoke(msg.sender, _txId);

        }


}  

   







