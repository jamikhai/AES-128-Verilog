// aes_shiftrows.v
`timescale 1ns/1ps

module aes_shiftrows (
    input  wire [127:0] in_state,
    output wire [127:0] out_state
);

    // Extract 16 bytes from the input state.
    // We assume that the state is stored in column-major order.
    wire [7:0] s0, s1, s2, s3,
               s4, s5, s6, s7,
               s8, s9, s10, s11,
               s12, s13, s14, s15;
               
    assign {s0, s1, s2, s3,
            s4, s5, s6, s7,
            s8, s9, s10, s11,
            s12, s13, s14, s15} = in_state;
    
    // Interpret the state as a 4x4 matrix in column-major order:
    //   Row 0: { s0,  s4,  s8,  s12 }
    //   Row 1: { s1,  s5,  s9,  s13 }
    //   Row 2: { s2,  s6,  s10, s14 }
    //   Row 3: { s3,  s7,  s11, s15 }
    //
    // After ShiftRows:
    //   Row 0: { s0,  s4,  s8,  s12 }      (no shift)
    //   Row 1: { s5,  s9,  s13, s1 }       (left shift by 1)
    //   Row 2: { s10, s14, s2,  s6 }       (left shift by 2)
    //   Row 3: { s15, s3,  s7,  s11 }      (left shift by 3)
    //
    // Reassemble the output state in column-major order:
    //   New Column 0: { s0, s5, s10, s15 }
    //   New Column 1: { s4, s9, s14, s3 }
    //   New Column 2: { s8, s13, s2, s7 }
    //   New Column 3: { s12, s1, s6, s11 }
    assign out_state = { s0, s5, s10, s15,
                         s4, s9, s14, s3,
                         s8, s13, s2, s7,
                         s12, s1, s6, s11 };

endmodule
