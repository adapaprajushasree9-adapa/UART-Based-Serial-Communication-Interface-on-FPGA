module uart_rx(
    input clk,
    input rst,

    input rx,
    input rx_en,

    output reg [7:0] rx_data,
    output reg rx_done
);

parameter idle_state  = 2'b00;
parameter start_state = 2'b01;
parameter data_state  = 2'b10;
parameter stop_state  = 2'b11;

reg [7:0] data;
reg [1:0] state;
reg [3:0] bit_count;
reg [4:0] sample_count;

always @(posedge clk)
begin

    if(rst)
    begin
        state <= idle_state;

        data <= 8'b0;
        bit_count <= 4'b0;
        sample_count <= 5'b0;
        rx_data <= 8'b0;
        rx_done <= 1'b0;

    end
    else
    begin

        case(state)

        idle_state :
                    begin

                     rx_done <= 1'b0;

                     if(rx == 1'b0)
                     begin
                        state <= start_state;
                        sample_count <= 0;
                     end
                    end

        start_state :
                     begin
                      
                      if(rx_en)
                      begin
                        sample_count <= sample_count + 1;

                        if(sample_count == 7)
                        begin
                         if(rx == 1'b0)
                         begin
                            state <= data_state;

                            sample_count <= 4'b0;
                            bit_count <= 4'b0;
                         end
                         else
                         begin
                            state <= idle_state;
                         end
                        end
                      end
                     end
        
        data_state : 
                    begin

                        if(rx_en)
                        begin

                            sample_count <= sample_count + 1;

                            if(sample_count == 15)
                            begin
                                data[bit_count] <= rx;

                                sample_count <= 0;

                                if(bit_count == 7)
                                begin
                                    state <= stop_state;
                                    bit_count <= 0;
                                end
                                else
                                    bit_count <= bit_count + 1;
                            end
                        end
                    end

        stop_state :            
                    begin

                        if(rx_en)
                        begin

                            sample_count <= sample_count + 1;

                            if(sample_count == 15)
                            begin
                                if(rx == 1'b1)
                                begin
                                    rx_data <= data;
                                    rx_done <= 1'b1;
                                    
                                end

                                state <= idle_state;
                                sample_count <= 0;
                            end
                        end
                    end

        default: state <= idle_state;

        endcase

    end
end

endmodule






