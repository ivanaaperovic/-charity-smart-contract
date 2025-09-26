# -charity-smart-contract
A secure Ethereum donation contract with pagination and reentrancy protection.
# Charity Smart Contract

A gas-efficient and secure Ethereum donation contract.

## Features
- Minimum donation enforcement (0.01 ETH).
- Paginated donation queries (max 50 per call).
- Reentrancy protection for withdrawals.
- ERC20 recovery function.

## How to Use
1. Deploy in [Remix IDE](https://remix.ethereum.org).
2. Call `donate()` with ETH.
3. Owner calls `withdraw()` to collect funds.
