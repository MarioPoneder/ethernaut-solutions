// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


contract ForcePay {

  constructor() public payable {
    require(msg.value >= 0.001 ether);
  }

  function destroyAndLeaveBalanceAt(address _target) external {
    selfdestruct(payable(_target));
  }
}
