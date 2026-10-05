# tasq-contracts

The on-chain layer of TasQ on Robinhood Chain: where jobs are registered, where
payment settles against a valid receipt, and where operator reputation is kept.

This repository is the public interface surface. It holds the interfaces, the
shared type library and the EIP-712 type hashes that clients and the coordinator
build against. The settlement logic, the audit sampling and the reputation curve
are implemented in a private repository until they are audited and deployed.

## Layout

```
src/
  libraries/TasqTypes.sol      shared enums, structs and EIP-712 type hashes
  interfaces/IIntentRegistry.sol   register and look up signed intents
  interfaces/ISettlement.sol       release or withhold payment on a receipt
  interfaces/IReputation.sol       read and update operator scores
```

## EIP-712 domain

Clients sign intents under the domain `{ name: "TasQ", version: "1", chainId }`.
A `verifyingContract` is added once settlement is deployed. The intent type hash
in `TasqTypes.sol` matches the types in
[`@tasqnetwork/sdk`](https://github.com/tasqProject/tasq-sdk). Keep the two in
sync: a mismatch makes every signature fail.

## Build

```
forge build
```

## Status

Pre-launch. Addresses are not assigned and the interfaces may change before
audit. Do not treat anything here as deployed.

## License

Apache License 2.0. See `LICENSE`. Copyright The TasQ Project.
