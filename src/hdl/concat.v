module concat_2 #(
    parameter IN_0_WIDTH = 1,
    parameter IN_1_WIDTH = 2
) (
    input wire [IN_0_WIDTH-1:0] in_0,
    input wire [IN_1_WIDTH-1:0] in_1,
    output wire [IN_0_WIDTH+IN_1_WIDTH-1:0] out_0
);

assign out_0[IN_0_WIDTH-1:0] = in_0[IN_0_WIDTH-1:0];
assign out_0[IN_0_WIDTH+IN_1_WIDTH-1:IN_0_WIDTH] = in_1[IN_1_WIDTH-1:0];

endmodule