`timescale 1 ns / 1 ps

module adc_rate_changer_tb();

    logic   clkin320, clkout320, dcm_reset, dcm_locked;
    logic   [1:0][15:0]     i_in;
    logic   [1:0][15:0]     q_in;
    logic   [15:0]     i_out;
    logic   [15:0]     q_out;
    
    localparam clk_period = 10;
    logic   clkin160 = 0;
    always #(clk_period/2) clkin160 = ~clkin160;
  
    initial begin
        dcm_reset = 1;
        #(clk_period*10);
        dcm_reset = 0;
     end

    adc_rate_changer uut(.*);
    
    assign clkin320 = ~clkout320;
    
    always_ff @(posedge clkin160) begin
        if(dcm_locked == 0) begin
            i_in[1] <= 1;
            i_in[0] <= 0;
            q_in[1] <= 1;
            q_in[0] <= 0;
        end else begin
            i_in[1] += 2;
            i_in[0] += 2;            
            q_in[1] += 2;
            q_in[0] += 2;
        end
    end
  
endmodule
