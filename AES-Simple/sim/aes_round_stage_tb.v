// aes_round_stage_tb.v
`timescale 1ns/1ps

module aes_round_stage_tb;

    // Inputs to the round stage module
    reg         disable_mix;
    reg  [127:0] in_state;
    reg  [127:0] round_key;
    
    // Output from the round stage module
    wire [127:0] out_state;
    
    // Expected output
    reg [127:0] expected_output;
    
    // Instantiate the unified round-stage module
    aes_round_stage uut (
        .disable_mix(disable_mix),
        .in_state(in_state),
        .round_key(round_key),
        .out_state(out_state)
    );
    
    initial begin
        // For a full round (rounds 1-9), disable_mix = 0 so MixColumns is used.
        disable_mix = 0;

        // Set the test vector from FIPS 197 Test Case Round 1:
        // Initial state after AddRoundKey to input
        in_state        = 128'h193de3bea0f4e22b9ac68d2ae9f84808;
        // Round 1 key (from key expansion)
        round_key       = 128'ha0fafe1788542cb123a339392a6c7605;
        // Expected output after round 1 transformation:
        expected_output = 128'ha49c7ff2689f352b6b5bea43026a5049;
        
        #10; // Wait for combinational logic to settle
        
        if (out_state === expected_output)
            $display("PASS: out_state = %h", out_state);
        else
            $display("FAIL: out_state = %h, expected = %h", out_state, expected_output);
        
        // Test final round: disable_mix = 1 so MixColumns is not used.
        disable_mix = 1;

        // Set the test vector from FIPS 197 Test Case Round 10:
        // Initial state at start of round 10
        in_state        = 128'heb40f21e592e38848ba113e71bc342d2;
        // Round 1 key (from key expansion)
        round_key       = 128'hd014f9a8c9ee2589e13f0cc8b6630ca6;
        // Expected output after round 1 transformation:
        expected_output = 128'h3925841d02dc09fbdc118597196a0b32;
        
        #10; // Wait for combinational logic to settle
        
        if (out_state === expected_output)
            $display("PASS: out_state = %h", out_state);
        else
            $display("FAIL: out_state = %h, expected = %h", out_state, expected_output);
        
        #10;
        $finish;
    end

endmodule
