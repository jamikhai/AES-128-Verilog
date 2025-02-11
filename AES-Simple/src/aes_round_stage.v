// aes_round_stage.v
module aes_round_stage (
    input  wire [127:0] in_state,
    input  wire [127:0] round_key,
    output wire [127:0] out_state
);

    wire [127:0] subbytes_out;
    wire [127:0] shiftrows_out;
    wire [127:0] mixcolumns_out;

    aes_subbytes u_subbytes (
        .in_state(in_state),
        .out_state(subbytes_out)
    );

    aes_shiftrows u_shiftrows (
        .in_state(subbytes_out),
        .out_state(shiftrows_out)
    );

    aes_mixcolumns u_mixcolumns (
        .in_state(shiftrows_out),
        .out_state(mixcolumns_out)
    );

    aes_addroundkey u_addroundkey (
        .in_state(mixcolumns_out),
        .round_key(round_key),
        .out_state(out_state)
    );
    
endmodule
