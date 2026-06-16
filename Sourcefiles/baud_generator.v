module baud_generator(
    input clk,
    input rst,

    output wire tx_en,
    output wire rx_en
);

reg [13:0] tx_counter;
reg [9:0]  rx_counter;

always @(posedge clk)
begin
    if(rst)
        tx_counter <= 0;
    else if(tx_counter == 10416)
        tx_counter <= 0;
    else
        tx_counter <= tx_counter + 1;
end

always @(posedge clk)
begin
    if(rst)
        rx_counter <= 0;
    else if(rx_counter == 650)
        rx_counter <= 0;
    else
        rx_counter <= rx_counter + 1;
end

assign tx_en = (tx_counter == 0);
assign rx_en = (rx_counter == 0);

endmodule