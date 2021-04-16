module top(
    input clk_25mhz,
    output wifi_gpio0,
    output reg [7:0] led,
    input [6:0] btn
    );

reg [7:0] bus_in_a = 8'b10011001;
reg [7:0] bus_in_b = 8'h55;
reg [7:0] bus_in_c = 8'haa;
reg [7:0] bus_in_d = 8'b01100110;

wire [7:0] mainbus;

bus #(.WIDTH(8),.COUNT(4)) mainbus1 (
    .in({
        bus_in_a,
        bus_in_b,
        bus_in_c,
        bus_in_d
    }),
    .enable(
        btn[6:3]
    ),
    .out(mainbus)
);
reg [7:0] delayed_bus;
always @(posedge clk_25mhz)
begin
    delayed_bus <= mainbus;
    led <= delayed_bus;
end

assign wifi_gpio0 = 1'b1;

endmodule