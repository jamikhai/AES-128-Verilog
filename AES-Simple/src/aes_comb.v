// aes_comb.v
module aes_comb (
    input  wire [127:0] plaintext,  // 128-bit input data
    input  wire [127:0] key,        // 128-bit AES key
    output wire [127:0] ciphertext  // 128-bit encrypted output data
);

    // Intermediate state wires (combinational)
    wire [127:0] state0, state1, state2, state3, state4,
                 state5, state6, state7, state8, state9;

    // Round key wires for 11 round keys (initial + 10 rounds)
    wire [127:0] round_key0, round_key1, round_key2, round_key3, round_key4,
                 round_key5, round_key6, round_key7, round_key8, round_key9, round_key10;

    // Instantiate the Key Expansion module.
    // This module takes the 128-bit key and generates 11 round keys.
    aes_keyexpansion key_expansion (
        .key        (key),
        .round_key0 (round_key0),
        .round_key1 (round_key1),
        .round_key2 (round_key2),
        .round_key3 (round_key3),
        .round_key4 (round_key4),
        .round_key5 (round_key5),
        .round_key6 (round_key6),
        .round_key7 (round_key7),
        .round_key8 (round_key8),
        .round_key9 (round_key9),
        .round_key10(round_key10)
    );

    // Initial round: AddRoundKey (plaintext XOR initial key)
    aes_addroundkey u_init_add (
        .in_state (plaintext),
        .round_key(round_key0),
        .out_state(state0)
    );

    // Rounds 1 through 9: Full rounds with SubBytes, ShiftRows, MixColumns, and AddRoundKey
    aes_round_stage u_round1 (
        .disable_mix(0),
        .in_state (state0),
        .round_key(round_key1),
        .out_state(state1)
    );

    aes_round_stage u_round2 (
        .disable_mix(0),
        .in_state (state1),
        .round_key(round_key2),
        .out_state(state2)
    );

    aes_round_stage u_round3 (
        .disable_mix(0),
        .in_state (state2),
        .round_key(round_key3),
        .out_state(state3)
    );

    aes_round_stage u_round4 (
        .disable_mix(0),
        .in_state (state3),
        .round_key(round_key4),
        .out_state(state4)
    );

    aes_round_stage u_round5 (
        .disable_mix(0),
        .in_state (state4),
        .round_key(round_key5),
        .out_state(state5)
    );

    aes_round_stage u_round6 (
        .disable_mix(0),
        .in_state (state5),
        .round_key(round_key6),
        .out_state(state6)
    );

    aes_round_stage u_round7 (
        .disable_mix(0),
        .in_state (state6),
        .round_key(round_key7),
        .out_state(state7)
    );

    aes_round_stage u_round8 (
        .disable_mix(0),
        .in_state (state7),
        .round_key(round_key8),
        .out_state(state8)
    );

    aes_round_stage u_round9 (
        .disable_mix(0),
        .in_state (state8),
        .round_key(round_key9),
        .out_state(state9)
    );

    // Final round (round 10) without MixColumns
    aes_round_stage u_final_round (
        .disable_mix(1),
        .in_state (state9),
        .round_key(round_key10),
        .out_state(ciphertext)
    );

endmodule
