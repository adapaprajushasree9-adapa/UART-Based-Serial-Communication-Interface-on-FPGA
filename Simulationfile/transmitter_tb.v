module tx_tb;
reg clk;
reg rst;
reg tx_start;
reg tx_en;
reg [7:0] tx_data;

wire tx;
wire tx_done;

uart_tx dut(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_en(tx_en),
    .tx_data(tx_data),
    .tx_done(tx_done),
    .tx(tx)
);

always #5 clk = ~clk;

initial 
begin
      $monitor($time," state tx=%b tx_done=%b tx_en=%b ",tx,tx_done,tx_en);
      clk = 0;
      rst = 1;
      tx_en = 0;
      tx_start = 0;
      tx_data = 8'h55;//01010101

      #20 rst = 0;

      #20 tx_start = 1;
      #10 tx_start = 0;

      repeat(12)

      begin
        #50 tx_en = 1;
        #10 tx_en = 0;
      end

      #100
      $finish;
end

endmodule