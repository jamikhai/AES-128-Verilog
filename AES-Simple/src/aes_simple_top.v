// aes_simple_top.v
`timescale 1ns/1ps

module aes_simple_top(
    input  wire         clk,         // System clock
    input  wire         rst,         // Asynchronous reset
    input  wire         en,          // Enable signal: when high, latch inputs
    input  wire [127:0] plaintext,   // 128-bit input plaintext
    input  wire [127:0] key,         // 128-bit input key
    output reg  [127:0] ciphertext   // 128-bit output ciphertext
);

    // Internal registers to hold inputs
    reg [127:0] plaintext_reg;
    reg [127:0] key_reg;
    // Delayed enable signal for output latching
    reg         en_d;
    
    // Wire for combinational output from aes_comb block
    wire [127:0] ciphertext_comb;
    
    // Instantiate the combinational AES encryption block
    aes_comb u_aes_comb (
        .plaintext(plaintext_reg),
        .key(key_reg),
        .ciphertext(ciphertext_comb)
    );
    
    // Input capturing and enable delay:
    // On each rising clock edge, if rst is high, clear registers.
    // Otherwise, if en is high, latch plaintext and key.
    // Also, delay the enable signal by one cycle.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            plaintext_reg <= 128'b0;
            key_reg       <= 128'b0;
            en_d          <= 1'b0;
        end else begin
            en_d          <= en;
            if (en) begin
                plaintext_reg <= plaintext;
                key_reg       <= key;
            end
        end
    end
    
    // Output capturing: On the rising edge, if the delayed enable is high,
    // latch the combinational output into the ciphertext register.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 128'b0;
        end else begin
            if (en_d)
                ciphertext <= ciphertext_comb;
        end
    end

endmodule
