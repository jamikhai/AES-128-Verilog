// aes_keyexpansion.v
`timescale 1ns/1ps

module aes_keyexpansion(
    input  wire [127:0] key,
    output wire [127:0] round_key0,
    output wire [127:0] round_key1,
    output wire [127:0] round_key2,
    output wire [127:0] round_key3,
    output wire [127:0] round_key4,
    output wire [127:0] round_key5,
    output wire [127:0] round_key6,
    output wire [127:0] round_key7,
    output wire [127:0] round_key8,
    output wire [127:0] round_key9,
    output wire [127:0] round_key10
);

    // An array of 44 words (each 32-bit) will hold the expanded key.
    // For AES-128, the original key provides the first 4 words,
    // and 40 additional words are generated (total 44 words).
    wire [31:0] w [0:43];

    // The original key is divided into 4 words:
    assign w[0] = key[127:96];
    assign w[1] = key[95:64];
    assign w[2] = key[63:32];
    assign w[3] = key[31:0];

    //-------------------------------------------------------------------------
    // Function: rot_word
    // Description: Rotates a 32-bit word by 8 bits (i.e. one byte left-circular shift)
    // Example: {B0, B1, B2, B3} becomes {B1, B2, B3, B0}
    //-------------------------------------------------------------------------
    function [31:0] rot_word;
        input [31:0] in_word;
        begin
            rot_word = {in_word[23:0], in_word[31:24]};
        end
    endfunction

    //-------------------------------------------------------------------------
    // Function: s_box
    // Substitute a byte for a different value based on the AES spec
    //-------------------------------------------------------------------------
    function automatic [7:0] s_box;
        input [7:0] in_byte;
        begin
            case (in_byte)
                8'h00: s_box = 8'h63;
                8'h01: s_box = 8'h7c;
                8'h02: s_box = 8'h77;
                8'h03: s_box = 8'h7b;
                8'h04: s_box = 8'hf2;
                8'h05: s_box = 8'h6b;
                8'h06: s_box = 8'h6f;
                8'h07: s_box = 8'hc5;
                8'h08: s_box = 8'h30;
                8'h09: s_box = 8'h01;
                8'h0a: s_box = 8'h67;
                8'h0b: s_box = 8'h2b;
                8'h0c: s_box = 8'hfe;
                8'h0d: s_box = 8'hd7;
                8'h0e: s_box = 8'hab;
                8'h0f: s_box = 8'h76;
                8'h10: s_box = 8'hca;
                8'h11: s_box = 8'h82;
                8'h12: s_box = 8'hc9;
                8'h13: s_box = 8'h7d;
                8'h14: s_box = 8'hfa;
                8'h15: s_box = 8'h59;
                8'h16: s_box = 8'h47;
                8'h17: s_box = 8'hf0;
                8'h18: s_box = 8'had;
                8'h19: s_box = 8'hd4;
                8'h1a: s_box = 8'ha2;
                8'h1b: s_box = 8'haf;
                8'h1c: s_box = 8'h9c;
                8'h1d: s_box = 8'ha4;
                8'h1e: s_box = 8'h72;
                8'h1f: s_box = 8'hc0;
                8'h20: s_box = 8'hb7;
                8'h21: s_box = 8'hfd;
                8'h22: s_box = 8'h93;
                8'h23: s_box = 8'h26;
                8'h24: s_box = 8'h36;
                8'h25: s_box = 8'h3f;
                8'h26: s_box = 8'hf7;
                8'h27: s_box = 8'hcc;
                8'h28: s_box = 8'h34;
                8'h29: s_box = 8'ha5;
                8'h2a: s_box = 8'he5;
                8'h2b: s_box = 8'hf1;
                8'h2c: s_box = 8'h71;
                8'h2d: s_box = 8'hd8;
                8'h2e: s_box = 8'h31;
                8'h2f: s_box = 8'h15;
                8'h30: s_box = 8'h04;
                8'h31: s_box = 8'hc7;
                8'h32: s_box = 8'h23;
                8'h33: s_box = 8'hc3;
                8'h34: s_box = 8'h18;
                8'h35: s_box = 8'h96;
                8'h36: s_box = 8'h05;
                8'h37: s_box = 8'h9a;
                8'h38: s_box = 8'h07;
                8'h39: s_box = 8'h12;
                8'h3a: s_box = 8'h80;
                8'h3b: s_box = 8'he2;
                8'h3c: s_box = 8'heb;
                8'h3d: s_box = 8'h27;
                8'h3e: s_box = 8'hb2;
                8'h3f: s_box = 8'h75;
                8'h40: s_box = 8'h09;
                8'h41: s_box = 8'h83;
                8'h42: s_box = 8'h2c;
                8'h43: s_box = 8'h1a;
                8'h44: s_box = 8'h1b;
                8'h45: s_box = 8'h6e;
                8'h46: s_box = 8'h5a;
                8'h47: s_box = 8'ha0;
                8'h48: s_box = 8'h52;
                8'h49: s_box = 8'h3b;
                8'h4a: s_box = 8'hd6;
                8'h4b: s_box = 8'hb3;
                8'h4c: s_box = 8'h29;
                8'h4d: s_box = 8'he3;
                8'h4e: s_box = 8'h2f;
                8'h4f: s_box = 8'h84;
                8'h50: s_box = 8'h53;
                8'h51: s_box = 8'hd1;
                8'h52: s_box = 8'h00;
                8'h53: s_box = 8'hed;
                8'h54: s_box = 8'h20;
                8'h55: s_box = 8'hfc;
                8'h56: s_box = 8'hb1;
                8'h57: s_box = 8'h5b;
                8'h58: s_box = 8'h6a;
                8'h59: s_box = 8'hcb;
                8'h5a: s_box = 8'hbe;
                8'h5b: s_box = 8'h39;
                8'h5c: s_box = 8'h4a;
                8'h5d: s_box = 8'h4c;
                8'h5e: s_box = 8'h58;
                8'h5f: s_box = 8'hcf;
                8'h60: s_box = 8'hd0;
                8'h61: s_box = 8'hef;
                8'h62: s_box = 8'haa;
                8'h63: s_box = 8'hfb;
                8'h64: s_box = 8'h43;
                8'h65: s_box = 8'h4d;
                8'h66: s_box = 8'h33;
                8'h67: s_box = 8'h85;
                8'h68: s_box = 8'h45;
                8'h69: s_box = 8'hf9;
                8'h6a: s_box = 8'h02;
                8'h6b: s_box = 8'h7f;
                8'h6c: s_box = 8'h50;
                8'h6d: s_box = 8'h3c;
                8'h6e: s_box = 8'h9f;
                8'h6f: s_box = 8'ha8;
                8'h70: s_box = 8'h51;
                8'h71: s_box = 8'ha3;
                8'h72: s_box = 8'h40;
                8'h73: s_box = 8'h8f;
                8'h74: s_box = 8'h92;
                8'h75: s_box = 8'h9d;
                8'h76: s_box = 8'h38;
                8'h77: s_box = 8'hf5;
                8'h78: s_box = 8'hbc;
                8'h79: s_box = 8'hb6;
                8'h7a: s_box = 8'hda;
                8'h7b: s_box = 8'h21;
                8'h7c: s_box = 8'h10;
                8'h7d: s_box = 8'hff;
                8'h7e: s_box = 8'hf3;
                8'h7f: s_box = 8'hd2;
                8'h80: s_box = 8'hcd;
                8'h81: s_box = 8'h0c;
                8'h82: s_box = 8'h13;
                8'h83: s_box = 8'hec;
                8'h84: s_box = 8'h5f;
                8'h85: s_box = 8'h97;
                8'h86: s_box = 8'h44;
                8'h87: s_box = 8'h17;
                8'h88: s_box = 8'hc4;
                8'h89: s_box = 8'ha7;
                8'h8a: s_box = 8'h7e;
                8'h8b: s_box = 8'h3d;
                8'h8c: s_box = 8'h64;
                8'h8d: s_box = 8'h5d;
                8'h8e: s_box = 8'h19;
                8'h8f: s_box = 8'h73;
                8'h90: s_box = 8'h60;
                8'h91: s_box = 8'h81;
                8'h92: s_box = 8'h4f;
                8'h93: s_box = 8'hdc;
                8'h94: s_box = 8'h22;
                8'h95: s_box = 8'h2a;
                8'h96: s_box = 8'h90;
                8'h97: s_box = 8'h88;
                8'h98: s_box = 8'h46;
                8'h99: s_box = 8'hee;
                8'h9a: s_box = 8'hb8;
                8'h9b: s_box = 8'h14;
                8'h9c: s_box = 8'hde;
                8'h9d: s_box = 8'h5e;
                8'h9e: s_box = 8'h0b;
                8'h9f: s_box = 8'hdb;
                8'ha0: s_box = 8'he0;
                8'ha1: s_box = 8'h32;
                8'ha2: s_box = 8'h3a;
                8'ha3: s_box = 8'h0a;
                8'ha4: s_box = 8'h49;
                8'ha5: s_box = 8'h06;
                8'ha6: s_box = 8'h24;
                8'ha7: s_box = 8'h5c;
                8'ha8: s_box = 8'hc2;
                8'ha9: s_box = 8'hd3;
                8'haa: s_box = 8'hac;
                8'hab: s_box = 8'h62;
                8'hac: s_box = 8'h91;
                8'had: s_box = 8'h95;
                8'hae: s_box = 8'he4;
                8'haf: s_box = 8'h79;
                8'hb0: s_box = 8'he7;
                8'hb1: s_box = 8'hc8;
                8'hb2: s_box = 8'h37;
                8'hb3: s_box = 8'h6d;
                8'hb4: s_box = 8'h8d;
                8'hb5: s_box = 8'hd5;
                8'hb6: s_box = 8'h4e;
                8'hb7: s_box = 8'ha9;
                8'hb8: s_box = 8'h6c;
                8'hb9: s_box = 8'h56;
                8'hba: s_box = 8'hf4;
                8'hbb: s_box = 8'hea;
                8'hbc: s_box = 8'h65;
                8'hbd: s_box = 8'h7a;
                8'hbe: s_box = 8'hae;
                8'hbf: s_box = 8'h08;
                8'hc0: s_box = 8'hba;
                8'hc1: s_box = 8'h78;
                8'hc2: s_box = 8'h25;
                8'hc3: s_box = 8'h2e;
                8'hc4: s_box = 8'h1c;
                8'hc5: s_box = 8'ha6;
                8'hc6: s_box = 8'hb4;
                8'hc7: s_box = 8'hc6;
                8'hc8: s_box = 8'he8;
                8'hc9: s_box = 8'hdd;
                8'hca: s_box = 8'h74;
                8'hcb: s_box = 8'h1f;
                8'hcc: s_box = 8'h4b;
                8'hcd: s_box = 8'hbd;
                8'hce: s_box = 8'h8b;
                8'hcf: s_box = 8'h8a;
                8'hd0: s_box = 8'h70;
                8'hd1: s_box = 8'h3e;
                8'hd2: s_box = 8'hb5;
                8'hd3: s_box = 8'h66;
                8'hd4: s_box = 8'h48;
                8'hd5: s_box = 8'h03;
                8'hd6: s_box = 8'hf6;
                8'hd7: s_box = 8'h0e;
                8'hd8: s_box = 8'h61;
                8'hd9: s_box = 8'h35;
                8'hda: s_box = 8'h57;
                8'hdb: s_box = 8'hb9;
                8'hdc: s_box = 8'h86;
                8'hdd: s_box = 8'hc1;
                8'hde: s_box = 8'h1d;
                8'hdf: s_box = 8'h9e;
                8'he0: s_box = 8'he1;
                8'he1: s_box = 8'hf8;
                8'he2: s_box = 8'h98;
                8'he3: s_box = 8'h11;
                8'he4: s_box = 8'h69;
                8'he5: s_box = 8'hd9;
                8'he6: s_box = 8'h8e;
                8'he7: s_box = 8'h94;
                8'he8: s_box = 8'h9b;
                8'he9: s_box = 8'h1e;
                8'hea: s_box = 8'h87;
                8'heb: s_box = 8'he9;
                8'hec: s_box = 8'hce;
                8'hed: s_box = 8'h55;
                8'hee: s_box = 8'h28;
                8'hef: s_box = 8'hdf;
                8'hf0: s_box = 8'h8c;
                8'hf1: s_box = 8'ha1;
                8'hf2: s_box = 8'h89;
                8'hf3: s_box = 8'h0d;
                8'hf4: s_box = 8'hbf;
                8'hf5: s_box = 8'he6;
                8'hf6: s_box = 8'h42;
                8'hf7: s_box = 8'h68;
                8'hf8: s_box = 8'h41;
                8'hf9: s_box = 8'h99;
                8'hfa: s_box = 8'h2d;
                8'hfb: s_box = 8'h0f;
                8'hfc: s_box = 8'hb0;
                8'hfd: s_box = 8'h54;
                8'hfe: s_box = 8'hbb;
                8'hff: s_box = 8'h16;
                default: s_box = 8'h00;
            endcase
        end
    endfunction


    //-------------------------------------------------------------------------
    // Function: sub_word
    // Description: Applies the s_box substitution to each of the 4 bytes of a 32-bit word.
    //-------------------------------------------------------------------------
    function [31:0] sub_word;
        input [31:0] in_word;
        begin
            sub_word = { s_box(in_word[31:24]),
                         s_box(in_word[23:16]),
                         s_box(in_word[15:8]),
                         s_box(in_word[7:0]) };
        end
    endfunction

    //-------------------------------------------------------------------------
    // Function: rcon
    // Description: Returns the round constant for the given round.
    // For AES-128, rounds 1 to 10 have the following constants:
    //   Rcon[1] = 0x01000000, Rcon[2] = 0x02000000, Rcon[3] = 0x04000000, ...
    //-------------------------------------------------------------------------
    function [31:0] rcon;
        input integer round;
        begin
            case (round)
                1:  rcon = 32'h01000000;
                2:  rcon = 32'h02000000;
                3:  rcon = 32'h04000000;
                4:  rcon = 32'h08000000;
                5:  rcon = 32'h10000000;
                6:  rcon = 32'h20000000;
                7:  rcon = 32'h40000000;
                8:  rcon = 32'h80000000;
                9:  rcon = 32'h1B000000;
                10: rcon = 32'h36000000;
                default: rcon = 32'h00000000;
            endcase
        end
    endfunction

    //-------------------------------------------------------------------------
    // Key Expansion Loop
    // Description:
    // For each word index i from 4 to 43, the new word is computed as follows:
    //   - If i is a multiple of 4:
    //         w[i] = w[i-4] XOR (sub_word(rot_word(w[i-1])) XOR rcon(i/4))
    //   - Otherwise:
    //         w[i] = w[i-4] XOR w[i-1]
    //-------------------------------------------------------------------------
    genvar i;
    generate
        for (i = 4; i < 44; i = i + 1) begin : key_expansion_loop
            if (i % 4 == 0) begin : gen_rot_sub
                assign w[i] = w[i-4] ^ (sub_word(rot_word(w[i-1])) ^ rcon(i/4));
            end else begin : gen_normal
                assign w[i] = w[i-4] ^ w[i-1];
            end
        end
    endgenerate

    //-------------------------------------------------------------------------
    // Group the key words into round keys.
    // Each round key is 128 bits (4 words):
    //   round_key0  = {w[0],  w[1],  w[2],  w[3]}
    //   round_key1  = {w[4],  w[5],  w[6],  w[7]}
    //   ...
    //   round_key10 = {w[40], w[41], w[42], w[43]}
    //-------------------------------------------------------------------------
    assign round_key0  = { w[0],  w[1],  w[2],  w[3]  };
    assign round_key1  = { w[4],  w[5],  w[6],  w[7]  };
    assign round_key2  = { w[8],  w[9],  w[10], w[11] };
    assign round_key3  = { w[12], w[13], w[14], w[15] };
    assign round_key4  = { w[16], w[17], w[18], w[19] };
    assign round_key5  = { w[20], w[21], w[22], w[23] };
    assign round_key6  = { w[24], w[25], w[26], w[27] };
    assign round_key7  = { w[28], w[29], w[30], w[31] };
    assign round_key8  = { w[32], w[33], w[34], w[35] };
    assign round_key9  = { w[36], w[37], w[38], w[39] };
    assign round_key10 = { w[40], w[41], w[42], w[43] };

endmodule
