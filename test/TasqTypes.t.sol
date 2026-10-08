// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

import { Test } from "forge-std/Test.sol";
import { TasqTypes } from "../src/libraries/TasqTypes.sol";

/// @notice Tests for the shared type library. Run with `forge test`.
contract TasqTypesTest is Test {
    function test_IntentTypehash() public pure {
        bytes32 expected = keccak256(
            "Intent(string mode,string model,bytes32 inputCommitment,uint256 budget,uint64 deadline,bytes32 nonce)"
        );
        assertEq(TasqTypes.INTENT_TYPEHASH, expected);
    }

    function test_HashIntentIsDeterministic() public pure {
        TasqTypes.Intent memory intent = _intent();
        bytes32 a = TasqTypes.hashIntent(intent, "A");
        bytes32 b = TasqTypes.hashIntent(intent, "A");
        assertEq(a, b);
        // The mode string is part of the hash, so a different mode must differ.
        assertTrue(TasqTypes.hashIntent(intent, "R") != a);
    }

    function test_HashIntentMatchesManualEncoding() public pure {
        TasqTypes.Intent memory intent = _intent();
        bytes32 manual = keccak256(
            abi.encode(
                TasqTypes.INTENT_TYPEHASH,
                keccak256(bytes("A")),
                keccak256(bytes(intent.model)),
                intent.inputCommitment,
                intent.budget,
                intent.deadline,
                intent.nonce
            )
        );
        assertEq(TasqTypes.hashIntent(intent, "A"), manual);
    }

    function _intent() internal pure returns (TasqTypes.Intent memory) {
        return TasqTypes.Intent({
            mode: TasqTypes.Mode.Attested,
            model: "llama-3.1-8b-instruct",
            inputCommitment: keccak256("input"),
            budget: 5 ether,
            deadline: 1_700_000_000,
            nonce: keccak256("nonce")
        });
    }
}
