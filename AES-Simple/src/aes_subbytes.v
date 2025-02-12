// aes_subbytes.v
`timescale 1ns/1ps

module aes_subbytes (
    input  wire [127:0] in_state,
    output wire [127:0] out_state
);
    genvar i;
    generate
        // Instantiate 16 S-boxes for the 16 bytes of the 128-bit state.
        for (i = 0; i < 16; i = i + 1)
        begin : sbox_gen
            // The indexed part select [127 - (i*8) -: 8] selects 8 bits,
            // starting from bit 127 - i*8, going downward.
            aes_sbox sbox_inst (
                .in_byte(in_state[127 - (i*8) -: 8]),
                .out_byte(out_state[127 - (i*8) -: 8])
            );
        end
    endgenerate
endmodule
