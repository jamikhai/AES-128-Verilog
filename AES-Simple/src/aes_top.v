// aes_top.v
module aes_top (
    input  wire         clk,        // Clock signal for synchronous operation
    input  wire         rst,        // Asynchronous reset
    input  wire         start,      // Start signal to trigger encryption
    input  wire [127:0] plaintext,  // 128-bit input data
    input  wire [127:0] key,        // 128-bit AES key
    output reg  [127:0] ciphertext, // 128-bit encrypted output data
    output reg          done        // High for one clock cycle when encryption is complete
);

    // Intermediate state wires (combinational)
    wire [127:0] state0, state1, state2, state3, state4,
                 state5, state6, state7, state8, state9, state10;

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
        .in_state (state0),
        .round_key(round_key1),
        .out_state(state1)
    );

    aes_round_stage u_round2 (
        .in_state (state1),
        .round_key(round_key2),
        .out_state(state2)
    );

    aes_round_stage u_round3 (
        .in_state (state2),
        .round_key(round_key3),
        .out_state(state3)
    );

    aes_round_stage u_round4 (
        .in_state (state3),
        .round_key(round_key4),
        .out_state(state4)
    );

    aes_round_stage u_round5 (
        .in_state (state4),
        .round_key(round_key5),
        .out_state(state5)
    );

    aes_round_stage u_round6 (
        .in_state (state5),
        .round_key(round_key6),
        .out_state(state6)
    );

    aes_round_stage u_round7 (
        .in_state (state6),
        .round_key(round_key7),
        .out_state(state7)
    );

    aes_round_stage u_round8 (
        .in_state (state7),
        .round_key(round_key8),
        .out_state(state8)
    );

    aes_round_stage u_round9 (
        .in_state (state8),
        .round_key(round_key9),
        .out_state(state9)
    );

    // Final round: SubBytes, ShiftRows, and AddRoundKey (without MixColumns)
    aes_final_round u_final_round (
        .in_state (state9),
        .round_key(round_key10),
        .out_state(state10)
    );

    // Synchronous block: when a start signal is received, latch the final state
    // into the output register and assert done for one clock cycle.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 128'b0;
            done       <= 1'b0;
        end else begin
            if (start) begin
                // When start is asserted, the entire combinational chain is assumed
                // to compute the encryption result, which is then captured.
                ciphertext <= state10;
                done       <= 1'b1;
            end else begin
                // Clear the done flag in subsequent cycles.
                done       <= 1'b0;
            end
        end
    end

endmodule
