module rx_tb;

reg clk;
reg rst;

reg rx;
reg rx_en;

wire [7:0] rx_data;
wire rx_done;

uart_rx dut(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .rx_en(rx_en),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

always #5 clk = ~clk;

initial
begin

    $monitor($time,"  rx=%b rx_data=%b rx_done=%b",rx,rx_data,rx_done);
    $dumpfile("uart_rx.vcd");
    $dumpvars(0,rx_tb);

     clk = 0;
    rst = 1;
    rx = 1;
    rx_en = 0;

    #20;
    rst = 0;

    //start bit
    rx = 0;

    repeat(16)
    begin
        #10 rx_en = 1;
        #10 rx_en = 0;
    end
    
    rx = 1;

    //d0 = 1
    repeat(16)
    begin
        #10 rx_en = 1;
        #10 rx_en = 0;
    end

    //d1 = 0
     rx = 0;

    repeat(16)
    begin
        #10 rx_en = 1;
        #10 rx_en = 0;
    end

    //d2 = 1
    rx = 1;

    repeat(16)
    begin
        #10 rx_en = 1;
        #10 rx_en = 0;
    end
    
    //d3 = 0
    rx = 0;

    repeat(16)
    begin
        #10 rx_en = 1;
        #10 rx_en = 0;
    end
    
    //d4 = 1
    rx = 1;

    repeat(16)
    begin
        #10 rx_en = 1;
        #10 rx_en = 0;
    end

    //d5 = 0
    rx = 0;

    repeat(16)
    begin
        #10 rx_en = 1;
        #10 rx_en = 0;
    end
    
    //d6 = 1
    rx = 1;

    repeat(16)
    begin
        #10 rx_en = 1;
        #10 rx_en = 0;
    end

    // d7 = 0
    rx = 0;

    repeat(16)
    begin
        #10 rx_en = 1;
        #10 rx_en = 0;
    end

    // stop bit
    rx = 1;

    repeat(16)
    begin
        #10 rx_en = 1;
        #10 rx_en = 0;
    end

    #100;

    $finish;
end

endmodule
    







    