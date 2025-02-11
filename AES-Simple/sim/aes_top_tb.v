// aes_top_tb.v
`timescale 1ns/1ps

module aes_top_tb;

    // Testbench signals
    reg         clk;
    reg         rst;
    reg [127:0] plaintext;
    reg [127:0] key;
    wire [127:0] ciphertext;

    // Instantiate the AES top module under test
    aes_top uut (
        .clk(clk),
        .rst(rst),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext)
    );

    // Clock generation (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus: apply a known AES-128 test vector and check the output.
    // Standard AES-128 FIPS-197 test vector:
    // Plaintext:  00112233445566778899aabbccddeeff
    // Key:        000102030405060708090a0b0c0d0e0f
    // Expected Ciphertext: 69c4e0d86a7b0430d8cdb78070b4c55a
    initial begin
        // Initialize signals
        rst = 1;
        plaintext = 128'h0;
        key       = 128'h0;
        #10;
        rst = 0;

        // Apply test vector
        plaintext = 128'h00112233445566778899aabbccddeeff;
        key       = 128'h000102030405060708090a0b0c0d0e0f;

        // Wait sufficient time for combinational logic to settle
        #20;
        
        // Self-check: Compare the computed ciphertext with the expected value.
        if (ciphertext === 128'h69c4e0d86a7b0430d8cdb78070b4c55a) begin
            $display("TEST PASSED: ciphertext = %h", ciphertext);
        end else begin
            $display("TEST FAILED: expected 69c4e0d86a7b0430d8cdb78070b4c55a, got %h", ciphertext);
        end

        #10;
        $finish;
    end

endmodule
