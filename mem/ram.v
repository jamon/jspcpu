module ram(
  input clk,
  input [15:0] addr,
  input [7:0] data_in,
  input we,
  output reg [7:0] data_out
);

  reg [7:0] store[0:65535];
   initial
  begin
	$readmemh("boot.mem", store);
  end

  always @(posedge clk)
	if (we)
	  store[addr] <= data_in;
	else
	  data_out <= store[addr];
endmodule
