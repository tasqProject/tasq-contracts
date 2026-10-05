// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

import { TasqTypes } from "../libraries/TasqTypes.sol";

/// @title ISettlement
/// @notice Escrows a client's budget and releases it to the operator when a
///         receipt passes verification for the intent's mode. A failed check
///         withholds payment and reports the operator to reputation.
interface ISettlement {
    /// @notice Emitted when a budget is escrowed for an intent.
    event Escrowed(bytes32 indexed intentHash, uint256 amount);

    /// @notice Emitted when a receipt settles and the operator is paid.
    event Settled(bytes32 indexed intentHash, address indexed operator, uint256 amount);

    /// @notice Emitted when a receipt fails verification. No payment is made.
    event Rejected(bytes32 indexed intentHash, address indexed operator, string reason);

    /// @notice Lock the budget for a registered, open intent.
    function escrow(bytes32 intentHash) external payable;

    /// @notice Submit a receipt to settle an intent. Pays the operator if the
    ///         receipt verifies for the intent's mode, otherwise reverts and
    ///         records the failure. Verification of mode specific evidence is
    ///         delegated to a verifier set by governance.
    /// @param receipt The operator's result evidence.
    /// @param operator The address to pay on success.
    function settle(TasqTypes.Receipt calldata receipt, address operator) external;

    /// @notice Refund the escrow to the client after the intent's deadline with
    ///         no valid receipt.
    function refund(bytes32 intentHash) external;
}
