// aes_addroundkey.v
module aes_addroundkey (
    input  wire [127:0] in_state,
    input  wire [127:0] round_key,
    output wire [127:0] out_state
);

    // Bitwise XOR the input state with the round key
    assign out_state = in_state ^ round_key;

endmodule
