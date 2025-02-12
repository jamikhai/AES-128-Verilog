// aes_simple_top_tb.v
`timescale 1ns/1ps

module aes_simple_top_tb;

    parameter CLOCK_PERIOD = 10;

    // Inputs to aes_simple_top
    reg         clk;
    reg         rst;
    reg         en;
    reg  [127:0] plaintext;
    reg  [127:0] key;
    // Output from aes_simple_top
    wire [127:0] ciphertext;
    
    // Instantiate the top-level AES module
    aes_simple_top uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext)
    );
    
    // File handling variables
    integer test_file, r;
    reg [127:0] file_plaintext, file_key, file_expected;
    reg [1023:0] line;  // buffer for each line, if needed

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end
    
    initial begin
        // Initialize inputs
        rst = 1;
        en  = 0;
        plaintext = 128'b0;
        key       = 128'b0;
        
        // Hold reset for a couple of clock cycles
        #(CLOCK_PERIOD*2);
        rst = 0;
        #(CLOCK_PERIOD);
        
        // Open test vector file
        // Path is relative to xsim directory (e.g. build\AES-Simple\AES-Simple.sim\sim_1\behav\xsim)
        test_file = $fopen("../../../../../../test/test_vectors.txt", "r");
        if (test_file == 0) begin
            $display("ERROR: could not open test_vectors.txt");
            $finish;
        end
        $display("Test file opened.");
        
        // Loop over all test vectors in the file
        while (!$feof(test_file)) begin
            // Read a line containing plaintext, key, and expected ciphertext in hex
            r = $fscanf(test_file, "%h %h %h\n", file_plaintext, file_key, file_expected);
            if (r != 3) begin
                $display("ERROR: Could not read test vector properly");
                $finish;
            end
            
            // Apply test vector
            plaintext = file_plaintext;
            key       = file_key;
            en        = 1;
            #(CLOCK_PERIOD); // Latch inputs
            en        = 0;
            #(CLOCK_PERIOD); // Wait for output to update
            
            if (ciphertext !== file_expected)
                $display("FAIL: For plaintext = %h, key = %h, got ciphertext = %h, expected = %h", 
                         file_plaintext, file_key, ciphertext, file_expected);
            else
                $display("PASS: For plaintext = %h, key = %h, got ciphertext = %h", 
                         file_plaintext, file_key, ciphertext);
                         
            #(CLOCK_PERIOD); // Wait a cycle before next test vector
        end
        
        $fclose(test_file);
        $finish;
    end

endmodule
