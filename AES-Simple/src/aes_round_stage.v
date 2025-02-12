// aes_round_stage.v
module aes_round_stage (
    input  wire         disable_mix, // When 1, bypass MixColumns (final round)
    input  wire [127:0] in_state,
    input  wire [127:0] round_key,
    output wire [127:0] out_state
);

    wire [127:0] subbytes_out;
    wire [127:0] shiftrows_out;
    wire [127:0] mixcolumns_out;
    wire [127:0] final_state;

    // SubBytes stage
    aes_subbytes u_subbytes (
        .in_state(in_state),
        .out_state(subbytes_out)
    );

    // ShiftRows stage
    aes_shiftrows u_shiftrows (
        .in_state(subbytes_out),
        .out_state(shiftrows_out)
    );

    // MixColumns stage
    aes_mixcolumns u_mixcolumns (
        .in_state(shiftrows_out),
        .out_state(mixcolumns_out)
    );

    // Use a mux to select either mixcolumns_out or shiftrows_out
    assign final_state = disable_mix ? shiftrows_out : mixcolumns_out;

    // AddRoundKey stage
    aes_addroundkey u_addroundkey (
        .in_state(final_state),
        .round_key(round_key),
        .out_state(out_state)
    );

endmodule
