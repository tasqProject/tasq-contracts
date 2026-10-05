// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

/// @title IReputation
/// @notice Tracks a score per operator that rises with settled jobs and falls
///         with rejected receipts and failed audits. The scheduler reads it to
///         decide which machines may take which modes. The exact curve is set by
///         the implementation and is not part of this interface.
interface IReputation {
    /// @notice Emitted whenever an operator's score changes.
    event ScoreUpdated(address indexed operator, uint256 score);

    /// @notice Current score for an operator, scaled to 1e18 for 1.0.
    function scoreOf(address operator) external view returns (uint256);

    /// @notice Record a successful settlement. Callable only by settlement.
    function recordSuccess(address operator) external;

    /// @notice Record a rejected receipt or a failed audit. Callable only by
    ///         settlement or the audit coordinator.
    function recordFailure(address operator) external;

    /// @notice True if the operator's score clears the threshold for a mode.
    function qualifies(address operator, uint8 mode) external view returns (bool);
}
