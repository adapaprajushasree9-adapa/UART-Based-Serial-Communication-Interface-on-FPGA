module uart_echo_top(
    input clk,          // 100 MHz Basys3 clock
    input rst,

    input uart_rx,
    output uart_tx,

    output reg [7:0] led
);

wire tx_en;
wire rx_en;

wire [7:0] rx_data;
wire rx_done;
wire tx_done;

reg tx_start;
reg [7:0] tx_data;

baud_generator bg(
    .clk(clk),
    .rst(rst),
    .tx_en(tx_en),
    .rx_en(rx_en)
);

uart_rx rx_inst(
    .clk(clk),
    .rst(rst),
    .rx(uart_rx),
    .rx_en(rx_en),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

uart_tx tx_inst(
    .clk(clk),
    .rst(rst),
    .tx_en(tx_en),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(uart_tx),
    .tx_done(tx_done)
);

always @(posedge clk)
begin
    if(rst)
    begin
        tx_start <= 1'b0;
        tx_data  <= 8'b0;
        led      <= 8'b0;
    end
    else
    begin
        // default
        tx_start <= 1'b0;

        if(rx_done)
        begin
            tx_data  <= rx_data;   // echo byte
            tx_start <= 1'b1;      // one-clock pulse

            led <= rx_data;        // display on LEDs
        end
    end
end

endmodule