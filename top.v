
module top(
    input clk_25mhz,
    output wifi_gpio0,
    output reg [7:0] led,
    input [6:0] btn
    // output reg [3:0] audio_l,
    // output reg [3:0] audio_r
    );

reg [7:0] bus_in_a = 8'b10011001;
reg [7:0] bus_in_b = 8'h55;
reg [7:0] bus_in_c = 8'haa;
reg [7:0] bus_in_d = 8'b01100110;
reg [3:0] en_in = 4'b0000;
wire [7:0] data;

bus #(.WIDTH(8),.COUNT(4)) top1 (
    .in({bus_in_a,bus_in_b,bus_in_c,bus_in_d}),.enable(btn[6:3]), .out(data)
);

//encoder #(.LINES(8)) e0 (.unitary_in(btn), .binary_out(data));
// encoder #(.IN_WIDTH(7)) e0 (.in(btn), .out(data));

always @(posedge clk_25mhz)
    led <= data;

/*
reg [21:0] counter;
initial 
begin
    counter = 0;
    led[7:0] = 8'b10100000;
end

always @(posedge clk_25mhz) 
    counter <= counter + 1;

always @(posedge clk_25mhz) 
    if(counter==0)
    begin
        {led[7], led[6:0]} = {led[0], led[7:1]};
    end
*/
assign wifi_gpio0 = 1'b1;

endmodule