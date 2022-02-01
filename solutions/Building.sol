// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface IElevator {
  function floor() external view returns (uint);
  function goTo(uint _floor) external;
}


contract Building {

  function isLastFloor(uint _floor) external returns (bool) {
    return _floor == IElevator(msg.sender).floor();
  }

  function goToTop(address _elevatorContract) external {
    IElevator elevatorContract = IElevator(_elevatorContract);
    elevatorContract.goTo(elevatorContract.floor() + 1);
  }
}
