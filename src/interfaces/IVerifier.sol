// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

import { TasqTypes } from "../libraries/TasqTypes.sol";

/// @title IVerifier
/// @notice Checks the mode specific evidence in a receipt. Settlement delegates
///         to the verifier registered for a receipt's mode, so the proof and
///         attestation logic can be upgraded and audited on its own.
interface IVerifier {
    /// @notice The mode this verifier handles.
    function mode() external view returns (TasqTypes.Mode);

    /// @notice Verify a receipt's evidence against its commitments.
    /// @dev Must be a view: verification reads state (roots of trust, verifying
    ///      keys) but never mutates it. Returns false rather than reverting on a
    ///      malformed receipt, so settlement can record a clean rejection.
    /// @param receipt The receipt to check.
    /// @return ok True if the evidence proves the result for this mode.
    function verify(TasqTypes.Receipt calldata receipt) external view returns (bool ok);
}

/// @title IVerifierRegistry
/// @notice Maps each mode to the verifier that settlement should call.
interface IVerifierRegistry {
    /// @notice Emitted when governance sets the verifier for a mode.
    event VerifierSet(TasqTypes.Mode indexed mode, address verifier);

    /// @notice The verifier currently registered for a mode.
    function verifierOf(TasqTypes.Mode mode) external view returns (IVerifier);

    /// @notice Set the verifier for a mode. Restricted to governance.
    function setVerifier(TasqTypes.Mode mode, IVerifier verifier) external;
}
