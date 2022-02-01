// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface GatekeeperOne {
  function enter(bytes8 _gateKey) external returns (bool);
}


contract GatebreakerOne {

  // gateOne: call from contract
  // gateTwo: monitor gas usage in debugger
  // gateThree: learn what those typecasts do on a byte level
  constructor(address _gatekeeperContract) public {
    GatekeeperOne gatekeeperContract = GatekeeperOne(_gatekeeperContract);

    bytes8 gateKey = bytes8(uint64(uint16(tx.origin))) /* pass part one and three */ | bytes1(uint8(1)) /* add highest byte to pass part two */;
    (bool success, ) = _gatekeeperContract.call{gas: 8191*10 /* enough gas for function */ + 254 /* exact gas till gateTwo */}(abi.encodeWithSelector(gatekeeperContract.enter.selector, gateKey));
    require(success);
  }
}
