// aes_subbytes_tb.v
`timescale 1ns/1ps

module aes_subbytes_tb;

    // Testbench signals
    reg  [127:0] in_state;
    wire [127:0] out_state;
    reg [127:0] expected_output;

    // Instantiate the aes_subbytes module
    aes_subbytes uut (
        .in_state(in_state),
        .out_state(out_state)
    );

    initial begin
        // Apply test input: bytes 0x00, 0x01, ..., 0x0F in order
        in_state = 128'h000102030405060708090A0B0C0D0E0F;
        #10; // Wait for combinational propagation

        // Expected output:
        // According to the S-box mapping:
        // 0x00 -> 0x63, 0x01 -> 0x7c, 0x02 -> 0x77, 0x03 -> 0x7b,
        // 0x04 -> 0xf2, 0x05 -> 0x6b, 0x06 -> 0x6f, 0x07 -> 0xc5,
        // 0x08 -> 0x30, 0x09 -> 0x01, 0x0A -> 0x67, 0x0B -> 0x2b,
        // 0x0C -> 0xfe, 0x0D -> 0xd7, 0x0E -> 0xab, 0x0F -> 0x76.
        // Therefore, expected out_state is:
        expected_output = 128'h637c777bf26b6fc53001672bfed7ab76;
        
        if (out_state === expected_output) begin
            $display("PASS: out_state = %h", out_state);
        end else begin
            $display("FAIL: out_state = %h, expected = %h", out_state, 128'h637c777bf26b6fc53001672bfed7ab76);
        end

        #10;
        $finish;
    end

endmodule