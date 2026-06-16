`timescale 1ns/1ps
module uart_top_tb;

reg clk;
reg rst;

reg tx_start;
reg [7:0] tx_data;

wire [7:0] rx_data;
wire rx_done;
wire tx_done;

top_module dut(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .tx_done(tx_done)
);

always #5 clk = ~clk;

initial
begin
    
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_top_tb);
    $monitor($time,"  tx_data=%h rx_data=%h tx_done=%b rx_done=%b",tx_data,rx_data,tx_done,rx_done);
    clk = 0;
    rst = 1;
    
    tx_start = 0;
    tx_data = 8'h00;

    #20 rst = 0;

    #20 tx_data = 8'h55;
        tx_start = 1;

    #10 tx_start = 0;

    #20000000 $finish;  

end
endmodule  