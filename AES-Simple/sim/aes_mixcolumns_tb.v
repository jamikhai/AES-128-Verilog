`timescale 1ns/1ps

module aes_mixcolumns_tb;

    // Input to the MixColumns module (column-major order)
    reg [127:0] in_state;
    // Output from the MixColumns module
    wire [127:0] out_state;

    reg [127:0] expected_output;

    // Instantiate the MixColumns module
    aes_mixcolumns uut (
        .in_state(in_state),
        .out_state(out_state)
    );

    initial begin
        // Set the input state (column-major order):
        // Column 0: d4, bf, 5d, 30
        // Column 1: e0, b4, 52, ae
        // Column 2: b8, 41, 11, f1
        // Column 3: 1e, 27, 98, e5
        in_state = 128'hd4bf5d30e0b452aeb84111f11e2798e5;
        #10; // Allow propagation delay

        // Expected output from standard test vector:
        expected_output = 128'h046681e5e0cb199a48f8d37a2806264c;
              
        if (out_state === expected_output)
            $display("PASS: out_state = %h", out_state);
        else
            $display("FAIL: out_state = %h, expected = %h", out_state, expected_output);

        #10;
        $finish;
    end

endmodule
