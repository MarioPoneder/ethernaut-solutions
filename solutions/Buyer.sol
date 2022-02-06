// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface IShop {
  function price() external view returns (uint);
  function isSold() external view returns (bool);
  function buy() external; 
}


contract Buyer{

  function buy(address _shopContract) external {
    IShop(_shopContract).buy();
  }

  function price() external view returns (uint) {
      IShop shopContract = IShop(msg.sender);
      return shopContract.isSold() ? 0 : shopContract.price();
  }
}
