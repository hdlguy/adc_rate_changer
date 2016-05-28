module adc_rate_changer (
    input   logic                   clkin160,
    output  logic                   clkout320,
    input   logic                   dcm_reset,
    output  logic                   dcm_locked,
    input   logic   [1:0][13:0]     i_in,
    input   logic   [1:0][13:0]     q_in,
    //
    output  logic   [13:0]          i_out,
    output  logic   [13:0]          q_out);

    // clock buffer and dcm
    adc_clk_wiz adc_clk_wiz_inst(.clkin160(clkin160),  .clkout320(clkout320), .reset(dcm_reset), .locked(dcm_locked));      

    // Make a synchronous mux control signal.
    logic div160 = 0;
    logic div160_q, div160_qq, mux_sel;
    always_ff @(posedge clkin160)  div160    <= ~div160;
    // cross clocks here
    always_ff @(posedge clkout320) div160_q  <= div160;
    always_ff @(posedge clkout320) div160_qq <= div160_q;
    always_ff @(posedge clkout320) mux_sel   <= div160_q ^ div160_qq;

    // 
    always_ff @(posedge clkout320) if (mux_sel == 1) i_out <= i_in[0]; else i_out <= i_in[1];
    always_ff @(posedge clkout320) if (mux_sel == 1) q_out <= q_in[0]; else q_out <= q_in[1];
    
endmodule

