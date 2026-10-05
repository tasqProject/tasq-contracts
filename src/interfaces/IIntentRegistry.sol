// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

import { TasqTypes } from "../libraries/TasqTypes.sol";

/// @title IIntentRegistry
/// @notice Records signed job intents so the coordinator and operators can refer
///         to them on chain, and so a budget can be escrowed against one.
interface IIntentRegistry {
    /// @notice Emitted when a client registers a signed intent.
    event IntentRegistered(bytes32 indexed intentHash, address indexed client, TasqTypes.Mode mode);

    /// @notice Emitted when an intent expires or is cancelled by its client.
    event IntentClosed(bytes32 indexed intentHash);

    /// @notice Register an intent. Reverts if the signature does not recover to
    ///         `msg.sender` or if the intent has already expired.
    /// @param intent The intent fields.
    /// @param signature The client's EIP-712 signature over the intent.
    /// @return intentHash The EIP-712 hash used as the intent id.
    function register(TasqTypes.Intent calldata intent, bytes calldata signature)
        external
        returns (bytes32 intentHash);

    /// @notice Cancel an open intent. Only the original client may call.
    function cancel(bytes32 intentHash) external;

    /// @notice True while an intent is registered and not yet expired or closed.
    function isOpen(bytes32 intentHash) external view returns (bool);

    /// @notice The client that registered an intent, or the zero address.
    function clientOf(bytes32 intentHash) external view returns (address);
}
