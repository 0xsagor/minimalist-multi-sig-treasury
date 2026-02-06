# Minimalist Multi-Sig Treasury

A professional-grade Multi-Signature (Multi-Sig) wallet designed for secure asset management. This contract ensures that no single individual can move funds or interact with external contracts without the required number of approvals from designated owners.

## Key Features
* **M-of-N Authorization:** Configurable threshold (e.g., 3-of-5) for transaction execution.
* **Transaction Queueing:** Transparently propose, view, and approve transactions.
* **Generic Execution:** Supports sending ETH and calling functions on other smart contracts (e.g., interacting with DeFi protocols).

## How it Works
1. **Submit:** An owner proposes a transaction.
2. **Approve:** Other owners sign the transaction.
3. **Execute:** Once the threshold is met, anyone can trigger the execution.



## Security Note
This contract uses a flat structure for simplicity but follows industry-standard security patterns to prevent reentrancy and unauthorized access.
