# Ethernaut - Solutions

## 1. Fallback

```
await contract.contribute({ value: toWei("0.0001") });
await contract.sendTransaction({ value: toWei("0.0001") });
await contract.withdraw();
```


## 2. Fallout

```
await contract.Fal1out({ value: toWei("0.0001") });
await contract.collectAllocations();
```


## 3. Coin Flip

Compile [CoinFlipAttack.sol](./solutions/CoinFlipAttack.sol) and deploy it to the Rinkeby testnet with e.g. Remix IDE and MetaMask (Injected Web3).
Do not forget to specify the level `instance` address when deploying the attacker contract (constructor).  
Afterwards, just call the `callFlipWithCorrectGuess()` function 10 times.


## 4. Telephone

Compile [TelephoneProxy.sol](./solutions/TelephoneProxy.sol) and deploy it to the Rinkeby testnet with e.g. Remix IDE and MetaMask (Injected Web3).
Afterwards, just call the `giveMeTelephoneOwnership(address _telephoneContract)` function with the level `instance` address as first argument.

## 5. Token

```
const balance = Number(await contract.balanceOf(player));
await contract.transfer(level /* can be any address except own */, balance + 1 /* create underflow in contract */);
```

## 6. Delegation

See solidity function [delegatecall](https://solidity-by-example.org/delegatecall/).
```
await contract.sendTransaction({ data: web3.eth.abi.encodeFunctionSignature("pwn()") });
```

## 7. Force

See solidity function [selfdestruct](https://solidity-by-example.org/hacks/self-destruct/).  
Compile [ForcePay.sol](./solutions/ForcePay.sol) and deploy it to the Rinkeby testnet with at least 0.001 ETH.
Afterwards, just call the `destroyAndLeaveBalanceAt(address _contract)` function with the level `instance` address as first argument.

## 8. Vault

```
const password = await web3.eth.getStorageAt(instance, 1); // get storage variable at index 1 of contract (although it's private!)
await contract.unlock(password);
```

## 9. King

Compile [King4Ever.sol](./solutions/King4Ever.sol) and deploy it to the Rinkeby testnet with at least 0.001 ETH and the level `instance` address as argument (constructor).
The fallback function of this contract is going to revert any subsequent transaction which is trying to claim the throne.

## 10. Re-entrancy

Compile [ReentranceAttack.sol](./solutions/ReentranceAttack.sol) and deploy it to the Rinkeby testnet with e.g. 0.0001 ETH and the level `instance` address as argument (constructor).
Afterwards, just call the `drainVictim()` function to steal all funds from the level contract. Once this is done, do not forget to call the `withdraw()` function to get the funds back to your wallet.

## 11. Elevator

Compile [Building.sol](./solutions/Building.sol) and deploy it to the Rinkeby testnet with e.g. Remix IDE and MetaMask (Injected Web3).
Afterwards, just call the `goToTop(address _elevatorContract)` function with the level `instance` address as first argument.

## 12. Privacy

See [Layout of State Variables in Storage](https://docs.soliditylang.org/en/v0.6.12/internals/layout_in_storage.html).
```
const data2_32 = await web3.eth.getStorageAt(instance, 5); // get private storage variable 'data[2]' from contract
const data2_16 = data2_32.substring(0, data2_32.length - 32); // remove last 16 bytes from data[2], i.e. typecast from bytes32 to bytes16
await contract.unlock(data2_16);
```

## 13. Gatekeeper One

See [Solidity - Conversions](https://www.tutorialspoint.com/solidity/solidity_conversions.htm).  
Compile [GatebreakerOne.sol](./solutions/GatebreakerOne.sol) and deploy it to the Rinkeby testnet with the level `instance` address as argument (constructor). Done!

## 14. Gatekeeper Two

See [Bypass Contract Size Check](https://solidity-by-example.org/hacks/contract-size/).  
Compile [GatebreakerTwo.sol](./solutions/GatebreakerTwo.sol) and deploy it to the Rinkeby testnet with the level `instance` address as argument (constructor). Done!


## 15. Naught Coin

Circumvent the token lock using (non-overrided) ERC20 base class functions:
```
const playerBalance = await contract.balanceOf(player);
await contract.approve(player, playerBalance); // approve self to transfer tokens using 'transferFrom' function

const tokenReceiver = web3.eth.accounts.create(); // create new account to receive tokens
await contract.transferFrom(player, tokenReceiver.address, playerBalance); // transfer tokens to new account
```

## 16. Preservation

See solidity function [delegatecall](https://solidity-by-example.org/delegatecall/).  
Compile [MadLibraryContract.sol](./solutions/MadLibraryContract.sol) and deploy it to the Rinkeby testnet with e.g. Remix IDE and MetaMask (Injected Web3).
Afterwards, just call the `attack1(address _preservationContract)` and `attack2(address _preservationContract)` functions with the level `instance` address as first argument.

