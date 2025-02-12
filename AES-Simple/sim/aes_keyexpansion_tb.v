`timescale 1ns/1ps

module aes_keyexpansion_tb;

    // Input to the DUT
    reg [127:0] key;

    // Outputs from the DUT: each round key
    wire [127:0] round_key0;
    wire [127:0] round_key1;
    wire [127:0] round_key2;
    wire [127:0] round_key3;
    wire [127:0] round_key4;
    wire [127:0] round_key5;
    wire [127:0] round_key6;
    wire [127:0] round_key7;
    wire [127:0] round_key8;
    wire [127:0] round_key9;
    wire [127:0] round_key10;

    // Instantiate the key expansion module
    aes_keyexpansion uut (
        .key(key),
        .round_key0(round_key0),
        .round_key1(round_key1),
        .round_key2(round_key2),
        .round_key3(round_key3),
        .round_key4(round_key4),
        .round_key5(round_key5),
        .round_key6(round_key6),
        .round_key7(round_key7),
        .round_key8(round_key8),
        .round_key9(round_key9),
        .round_key10(round_key10)
    );

    // Create an array of wires for the actual round keys
    wire [127:0] actual_keys[0:10];
    assign actual_keys[0]  = round_key0;
    assign actual_keys[1]  = round_key1;
    assign actual_keys[2]  = round_key2;
    assign actual_keys[3]  = round_key3;
    assign actual_keys[4]  = round_key4;
    assign actual_keys[5]  = round_key5;
    assign actual_keys[6]  = round_key6;
    assign actual_keys[7]  = round_key7;
    assign actual_keys[8]  = round_key8;
    assign actual_keys[9]  = round_key9;
    assign actual_keys[10] = round_key10;

    // Define an array for expected round keys
    reg [127:0] expected_keys[0:10];

    integer i;
    integer error_count;

    initial begin
        // Apply the test key (FIPS-197 test key)
        key = 128'h2b7e151628aed2a6abf7158809cf4f3c;

        // Set the expected round keys from FIPS-197
        expected_keys[0]  = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        expected_keys[1]  = 128'ha0fafe1788542cb123a339392a6c7605;
        expected_keys[2]  = 128'hf2c295f27a96b9435935807a7359f67f;
        expected_keys[3]  = 128'h3d80477d4716fe3e1e237e446d7a883b;
        expected_keys[4]  = 128'hef44a541a8525b7fb671253bdb0bad00;
        expected_keys[5]  = 128'hd4d1c6f87c839d87caf2b8bc11f915bc;
        expected_keys[6]  = 128'h6d88a37a110b3efddbf98641ca0093fd;
        expected_keys[7]  = 128'h4e54f70e5f5fc9f384a64fb24ea6dc4f;
        expected_keys[8]  = 128'head27321b58dbad2312bf5607f8d292f;
        expected_keys[9]  = 128'hac7766f319fadc2128d12941575c006e;
        expected_keys[10] = 128'hd014f9a8c9ee2589e13f0cc8b6630ca6;
        
        error_count = 0;
        #10; // Allow propagation

        // Compare each generated round key with the expected value
        for (i = 0; i < 11; i = i + 1) begin
            if (actual_keys[i] !== expected_keys[i]) begin
                $display("ERROR: Round key %0d mismatch: Expected: %h, Got: %h", i, expected_keys[i], actual_keys[i]);
                error_count = error_count + 1;
            end else begin
                $display("PASS: Round key %0d: %h", i, actual_keys[i]);
            end
        end

        if (error_count == 0)
            $display("All round keys match expected values.");
        else
            $display("Total errors: %0d", error_count);

        #10;
        $finish;
    end

endmodule
