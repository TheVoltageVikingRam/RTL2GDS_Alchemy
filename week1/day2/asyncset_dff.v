module dff_async_set (input clk, input async_Set , input d, output reg q);
always @ (posedge clk, posedge async_set)
begin
	if (async_set)
		q<=1'b1;
	else
		q<=d;
end
endmodule
