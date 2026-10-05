// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

/// @title TasqTypes
/// @notice Shared enums, structs and EIP-712 type hashes for the TasQ contracts.
/// @dev The Intent type hash must match the types signed by @tasqnetwork/sdk.
library TasqTypes {
    /// @notice Assurance mode. Encoded as the first byte of its letter: A, R, P.
    enum Mode {
        Attested, // A
        Redundant, // R
        Proven // P
    }

    /// @notice A signed request for work. `inputCommitment` is a BLAKE3 digest.
    struct Intent {
        Mode mode;
        string model;
        bytes32 inputCommitment;
        uint256 budget;
        uint64 deadline;
        bytes32 nonce;
    }

    /// @notice The result evidence an operator returns. Fields used depend on mode.
    struct Receipt {
        bytes32 intentHash;
        bytes32 inputCommitment;
        bytes32 outputCommitment;
        Mode mode;
        bytes evidence; // attestation (A), packed signatures (R) or proof (P)
    }

    /// @dev keccak256 of the EIP-712 Intent type string. Mode is signed as a string
    ///      ("A" | "R" | "P") on the client, matching the SDK.
    bytes32 internal constant INTENT_TYPEHASH = keccak256(
        "Intent(string mode,string model,bytes32 inputCommitment,uint256 budget,uint64 deadline,bytes32 nonce)"
    );

    /// @notice Hash an intent for EIP-712 signing. `modeString` is the letter form.
    function hashIntent(Intent memory intent, string memory modeString) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                INTENT_TYPEHASH,
                keccak256(bytes(modeString)),
                keccak256(bytes(intent.model)),
                intent.inputCommitment,
                intent.budget,
                intent.deadline,
                intent.nonce
            )
        );
    }
}
