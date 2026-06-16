module uart_tx(
    input clk,
    input rst,
    input tx_en,
    input tx_start,
    input [7:0] tx_data,

    output  reg tx,
    output  reg tx_done
);

//tx_en is from baud generator.
//tx_start is the signal that tells the tranmitter at what bit it need to start transmitting the data to receiver.
//tx is the serial output bit.
//tx_done is signal that is enabled when the data is completely transmitted.

parameter idle_state = 2'b00;
parameter start_state = 2'b01;
parameter data_state = 2'b10;
parameter stop_state = 2'b11;

reg [7:0] data;
reg [3:0] bit_count;
reg [1:0] state;

//bit_count is for counting the no of data bits transmitted.

always @(posedge clk)
begin
    if(rst)
      begin
          tx <= 1'b1;
          state <= idle_state;
          data <= 8'b0;
          bit_count <= 4'b0;
          tx_done <= 1'b0;
      end

    else
    begin
     
     case(state)
     
     idle_state :
                 begin
                      tx <= 1;
                      tx_done <= 0;

                      if(tx_start)
                         begin
                             state <= start_state;
                             data <= tx_data;
                             bit_count <= 0;
                         end
                      
                 end

    start_state :
                  begin
                      
                      tx <= 0;

                      if(tx_en)
                            state <= data_state;
                      else
                            state <= start_state;      
                  end

    data_state :              
                  begin
                      
                      tx <= data[0];

                      if(tx_en)
                      begin
                         data <= data >> 1;

                          if(bit_count == 7)
                          begin
                            state <= stop_state;
                            bit_count <= 0;
                          end
                          else
                            bit_count <= bit_count + 1;
                      end
                  end

    stop_state :
                   begin

                      tx <= 1;

                      if(tx_en)
                      begin
                         state <= idle_state;
                         tx_done <= 1;
                      end
                   end

    default : 
             state <= idle_state;

  endcase

    end

end
endmodule                

