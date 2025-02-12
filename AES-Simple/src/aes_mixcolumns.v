// aes_mixcolumns.v
module aes_mixcolumns(
    input  wire [127:0] in_state,
    output wire [127:0] out_state
);

    // Assume input state is in column-major order:
    // in_state = { s0, s1, s2, s3,  s4, s5, s6, s7,  s8, s9, s10, s11,  s12, s13, s14, s15 }
    wire [7:0] s0, s1, s2, s3,
               s4, s5, s6, s7,
               s8, s9, s10, s11,
               s12, s13, s14, s15;
               
    assign {s0, s1, s2, s3,
            s4, s5, s6, s7,
            s8, s9, s10, s11,
            s12, s13, s14, s15} = in_state;

    // Function: xtime
    // Multiply by 2 in GF(2^8)
    function [7:0] xtime;
        input [7:0] x;
        begin
            xtime = (x[7]) ? ((x << 1) ^ 8'h1b) : (x << 1);
        end
    endfunction

    // Process Column 0: bytes s0, s1, s2, s3
    wire [7:0] col0_a, col0_b, col0_c, col0_d;
    assign col0_a = xtime(s0)           ^ (xtime(s1) ^ s1) ^ s2          ^ s3;
    assign col0_b = s0                  ^ xtime(s1)           ^ (xtime(s2) ^ s2) ^ s3;
    assign col0_c = s0                  ^ s1                  ^ xtime(s2)          ^ (xtime(s3) ^ s3);
    assign col0_d = (xtime(s0) ^ s0)    ^ s1                  ^ s2          ^ xtime(s3);

    // Process Column 1: bytes s4, s5, s6, s7
    wire [7:0] col1_a, col1_b, col1_c, col1_d;
    assign col1_a = xtime(s4)           ^ (xtime(s5) ^ s5) ^ s6          ^ s7;
    assign col1_b = s4                  ^ xtime(s5)           ^ (xtime(s6) ^ s6) ^ s7;
    assign col1_c = s4                  ^ s5                  ^ xtime(s6)          ^ (xtime(s7) ^ s7);
    assign col1_d = (xtime(s4) ^ s4)    ^ s5                  ^ s6          ^ xtime(s7);

    // Process Column 2: bytes s8, s9, s10, s11
    wire [7:0] col2_a, col2_b, col2_c, col2_d;
    assign col2_a = xtime(s8)           ^ (xtime(s9) ^ s9) ^ s10         ^ s11;
    assign col2_b = s8                  ^ xtime(s9)           ^ (xtime(s10) ^ s10) ^ s11;
    assign col2_c = s8                  ^ s9                  ^ xtime(s10)         ^ (xtime(s11) ^ s11);
    assign col2_d = (xtime(s8) ^ s8)    ^ s9                  ^ s10         ^ xtime(s11);

    // Process Column 3: bytes s12, s13, s14, s15
    wire [7:0] col3_a, col3_b, col3_c, col3_d;
    assign col3_a = xtime(s12)           ^ (xtime(s13) ^ s13) ^ s14         ^ s15;
    assign col3_b = s12                  ^ xtime(s13)           ^ (xtime(s14) ^ s14) ^ s15;
    assign col3_c = s12                  ^ s13                  ^ xtime(s14)         ^ (xtime(s15) ^ s15);
    assign col3_d = (xtime(s12) ^ s12)    ^ s13                  ^ s14         ^ xtime(s15);

    // Reassemble the output state in column-major order.
    // The output columns are:
    // Column 0: { col0_a, col0_b, col0_c, col0_d }
    // Column 1: { col1_a, col1_b, col1_c, col1_d }
    // Column 2: { col2_a, col2_b, col2_c, col2_d }
    // Column 3: { col3_a, col3_b, col3_c, col3_d }
    assign out_state = { col0_a, col0_b, col0_c, col0_d,
                         col1_a, col1_b, col1_c, col1_d,
                         col2_a, col2_b, col2_c, col2_d,
                         col3_a, col3_b, col3_c, col3_d };

endmodule
