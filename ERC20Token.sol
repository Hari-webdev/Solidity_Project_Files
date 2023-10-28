  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.18;

  contract myToken{
      
       string public name;
       string public symbol;
       uint public decimals;
       uint public totalSupply;

       event Transfer(address indexed  _from , address indexed  _to , uint indexed  _value);

       mapping (address => uint) public balanceOf;
       mapping (address => mapping(address => uint)) public allowed; 

       // address : { address : uint }
  

       event Approved (address _from,address _to, uint _value);


       

       constructor(string memory _name, string memory _symbol , uint _decimals, uint _totalSupply){ 

              name = _name;
              symbol = _symbol;
              decimals = _decimals;
              totalSupply = _totalSupply;
              balanceOf[msg.sender] = totalSupply; // My 1 remix account had Total supply


       }

       function transfer(address _to, uint _value)    external returns(bool){
        require(_to != address(0), "Invalid to address"); 
        require(_value <= balanceOf[msg.sender], "Insufficent Balance");
        balanceOf[msg.sender] -=_value;  // Account1[total supply] (-) _value;
        balanceOf[_to] += _value;       // Account1 [_Reciver address] + _value;
        emit Transfer(msg.sender,_to ,_value );
        return true;


       }
         
         function approve(address _to, uint _value ) external {
            require(_to != address(0), "Invalid address");
            allowed[msg.sender][_to] = _value;
            emit Approved(msg.sender,_to,_value);
         } 


         function allowance(address _owner, address _receiver) external view returns(uint){
            return allowed[_owner][_receiver];
         }

         function transferFrom(address _from, address _to, uint _value) external returns(bool){
            require(_value <= balanceOf[_from], "InSufficient Token"); // amount should not be greater than balance
            require(allowed[_from][_to] <= _value , "Insufficient Token"); // 
            balanceOf[_from] -= _value;    // balance of msg.sender  -_value of variable uint amount reduce in msg.sender
            allowed[_from][_to] -= _value;
            balanceOf[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
         }










  }





  
