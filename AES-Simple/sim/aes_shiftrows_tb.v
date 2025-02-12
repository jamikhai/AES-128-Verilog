// aes_shiftrows_tb.v
`timescale 1ns/1ps

module aes_shiftrows_tb;

    // Input to the aes_shiftrows module (state in column-major order)
    reg [127:0] in_state;
    // Output from the aes_shiftrows module
    wire [127:0] out_state;
    // Expected output after applying ShiftRows
    reg [127:0] expected_output;

    // Instantiate the module under test
    aes_shiftrows uut (
        .in_state(in_state),
        .out_state(out_state)
    );

    initial begin
        // Provide the test vector in column-major order:
        // in_state = { Column0, Column1, Column2, Column3 }
        // Where:
        // Column0: {0x00, 0x01, 0x02, 0x03}
        // Column1: {0x04, 0x05, 0x06, 0x07}
        // Column2: {0x08, 0x09, 0x0A, 0x0B}
        // Column3: {0x0C, 0x0D, 0x0E, 0x0F}

        in_state = 128'hd42711aee0bf98f1b8b45de51e415230;
        #10; // Wait for combinational logic to settle

        // Expected output after ShiftRows (as calculated above):
        expected_output = 128'hd4bf5d30e0b452aeb84111f11e2798e5;
        if (out_state === expected_output)
            $display("PASS: out_state = %h", out_state);
        else
            $display("FAIL: out_state = %h, expected = %h", out_state, expected_output);

        #10;
        $finish;
    end

endmodule
