// aes_sub_word.v
`timescale 1ns/1ps

module aes_sub_word(
    input  wire [31:0] in_word,
    output wire [31:0] out_word
);
    // Break the 32-bit word into four 8-bit segments
    wire [7:0] byte0, byte1, byte2, byte3;
    assign byte0 = in_word[31:24];
    assign byte1 = in_word[23:16];
    assign byte2 = in_word[15:8];
    assign byte3 = in_word[7:0];

    // Instantiate the S-box module for each byte
    wire [7:0] sub_byte0, sub_byte1, sub_byte2, sub_byte3;
    aes_sbox sbox0 (
        .in_byte(byte0),
        .out_byte(sub_byte0)
    );
    aes_sbox sbox1 (
        .in_byte(byte1),
        .out_byte(sub_byte1)
    );
    aes_sbox sbox2 (
        .in_byte(byte2),
        .out_byte(sub_byte2)
    );
    aes_sbox sbox3 (
        .in_byte(byte3),
        .out_byte(sub_byte3)
    );

    // Concatenate the substituted bytes into the final 32-bit output word.
    assign out_word = {sub_byte0, sub_byte1, sub_byte2, sub_byte3};

endmodule
