module adc_rate_changer (
    output  logic   clkout320,
    input   logic   dcm_reset,
    output  logic   dcm_locked,
    input   logic   [1:0][13:0]     i_in,
    input   logic   [1:0][13:0]     q_in,
    //
    input   logic   clkin320,
    output  logic   [13:0]     i_out,
    output  logic   [13:0]     q_out);

    // clock buffer and dcm
    adc_clk_wiz adc_clk_wiz_inst(.clkin160(clkin160),  .clkout320(clkout320), .reset(dcm_reset), .locked(dcm_locked));      

    
    
endmodule

