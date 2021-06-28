module alu_op (
    input clk,

    input [3:0] operation,
    output alu_clk,
    output [3:0] logic_op,
    output [1:0] shift_select,
    output [1:0] carry_select
);
    reg [7:0] ops [0:15];
    initial begin
                                // operation        carry   lhs     rhs
        ops[0]  = 8'b00000000;  // no op            0       lhs     0
        ops[1]  = 8'b00010000;  // shift left       0       <<lhs   0
        ops[2]  = 8'b00100000;  // shift right      0       >>lhs   0
        ops[3]  = 8'b00001100;  // add              0       lhs     rhs
        ops[4]  = 8'b01001100;  // addc             prev    lhs     rhs
        ops[5]  = 8'b10000000;  // inc              1       lhs     0
        ops[6]  = 8'b01000000;  // incc             prev    lhs     0       
        ops[7]  = 8'b10000011;  // sub              1       lhs     ~rhs
        ops[8]  = 8'b01000011;  // subb             prev    lhs     ~rhs
        ops[9]  = 8'b00001111;  // dec              0       lhs     ~0
        ops[10] = 8'b00111000;  // and              0       0       lhs AND rhs
        ops[11] = 8'b00111110;  // or               0       0       lhs OR  rhs
        ops[12] = 8'b00110110;  // xor              0       0       lhs XOR rhs
        ops[13] = 8'b00110011;  // not              0       0       ~rhs
        ops[14] = 8'b00110000;  // clc              0       0       0
        ops[15] = 8'b00110000;  // unused           0       0       0
    end
    wire [7:0] current_op = ops[operation];
    assign logic_op = current_op[3:0];
    assign shift_select = current_op[5:4];
    assign carry_select = current_op[7:6];

    // generate alu clk
    wire select0 = ~|operation;         // select 0 is high when all operation bits are low (NOR reduction)
    // assign alu_clk = ~(~clk | select0); // alu_clk should mirror clk when select0 is low
    assign alu_clk = ~select0  & clk;

    // always @(posedge clk) begin
    //     case (operation) 
    //         4'b0000: begin              // no op
    //             carry_select <= 2'b00;      //
    //             shift_select <= 2'b00;      // lhs
    //             logic_op <= 4'b0000;        //
    //         end
    //         4'b0001: begin              // shift left
    //             carry_select <= 2'b00;      // 
    //             shift_select <= 2'b01;      // shl lhs
    //             logic_op <= 4'b0000;        // 0
    //         end
    //         4'b0010: begin              // shift right
    //             carry_select <= 2'b00;      //
    //             shift_select <= 2'b10;      // shr lhs
    //             logic_op <= 4'b0000;        // 0
    //         end
    //         4'b0011: begin              // add
    //             carry_select <= 2'b00;      // 
    //             shift_select <= 2'b00;      // lhs
    //             logic_op <= 4'b1100;        // rhs
    //         end
    //         4'b0100: begin              // addc
    //             carry_select <= 2'b01;      // prev carry?
    //             shift_select <= 2'b00;      // lhs
    //             logic_op <= 4'b1100;        // rhs
    //         end
    //         4'b0101: begin              // inc
    //             carry_select <= 2'b10;      // 1?
    //             shift_select <= 2'b00;      // lhs
    //             logic_op <= 4'b0000;        // 0
    //         end
    //         4'b0110: begin              // incc
    //             carry_select <= 2'b01;      // prev carry?
    //             shift_select <= 2'b00;      // lhs
    //             logic_op <= 4'b0000;        // 0
    //         end
    //         4'b0111: begin              // sub
    //             carry_select <= 2'b10;      // 1?
    //             shift_select <= 2'b00;      // lhs
    //             logic_op <= 4'b0011;        // ~rhs
    //         end
    //         4'b1000: begin              // subb
    //             carry_select <= 2'b01;      // prev carry?
    //             shift_select <= 2'b00;      // lhs
    //             logic_op <= 4'b0011;        // ~rhs
    //         end
    //         4'b1001: begin              // dec
    //             carry_select <= 2'b00;      // 0?
    //             shift_select <= 2'b00;      // lhs
    //             logic_op <= 4'b1111;        // ~0 (-1)
    //         end
    //         4'b1010: begin              // and
    //             carry_select <= 2'b00;      // 0?
    //             shift_select <= 2'b11;      // 0
    //             logic_op <= 4'b1000;        // AND
    //         end
    //         4'b1011: begin              // or
    //             carry_select <= 2'b00;      // 0
    //             shift_select <= 2'b11;      // 0
    //             logic_op <= 4'b1110;        // OR
    //         end
    //         4'b1100: begin              // xor
    //             carry_select <= 2'b00;      // 0
    //             shift_select <= 2'b11;      // 0
    //             logic_op <= 4'b0110;        // XOR
    //         end
    //         4'b1101: begin              // not
    //             carry_select <= 2'b00;      // 0
    //             shift_select <= 2'b11;      // 0
    //             logic_op <= 4'b0011;        // ~rhs
    //         end
    //         4'b1110: begin              // clc
    //             shift_select <= 2'b00;      // 0
    //             carry_select <= 2'b11;      // 0      
    //             logic_op <= 4'b0000;        // 0
    //         end
    //         4'b1111: begin              // unused?
    //             logic_op <= 4'b0000;
    //             shift_select <= 2'b00;
    //             carry_select <= 2'b00;
    //         end
    //     endcase        
    // end

endmodule
