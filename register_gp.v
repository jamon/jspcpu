module register_gp(
    input [7:0] bus_in,
    output [7:0] bus_out,
    output [7:0] lhs_out,
    output [7:0] rhs_out,
    input assert_lhs, assert_rhs, assert_bus, load_bus,
    output lhs_en, rhs_en, bus_en
    );
    reg [7:0] value;

    always @(posedge load_bus) begin
        value <= bus_in;
    end

    assign lhs_en = assert_lhs;
    assign rhs_en = assert_rhs;
    assign bus_en = assert_bus;

endmodule