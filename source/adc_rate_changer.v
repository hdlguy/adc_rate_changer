module adc_rate_changer (
    input   logic                   clkin320,
    input   logic                   clkin160,
    output  logic                   clkout320,
    input   logic                   dcm_reset,
    output  logic                   dcm_locked,
    input   logic   [1:0][15:0]     i_in,
    input   logic   [1:0][15:0]     q_in,
    //
    output  logic   [15:0]          i_out,
    output  logic   [15:0]          q_out);

    // dcm
    adc_clk_wiz adc_clk_wiz_inst(.clkin160(clkin160), .clkout320(clkout320), .reset(dcm_reset), .locked(dcm_locked));      

    // Make a synchronous mux control signal.
    logic div160 = 0;
    logic div160_q, div160_qq, mux_sel;
    always_ff @(posedge clkin160)  div160    <= ~div160;
    always_ff @(posedge clkout320) div160_q  <= div160;
    always_ff @(posedge clkout320) div160_qq <= div160_q;
    always_ff @(posedge clkout320) mux_sel   <= div160_q ^ div160_qq;

    // 
    logic   [15:0]  q_data, i_data;
    always_ff @(posedge clkout320) if (mux_sel == 1) i_data <= i_in[0]; else i_data <= i_in[1];
    always_ff @(posedge clkout320) if (mux_sel == 1) q_data <= q_in[0]; else q_data <= q_in[1];
    
    // cross between 320MHz clock domains using a shallow fifo.
    logic fifo_empty, fifo_full;
    adc_fifo fifo_inst (
        .rst(~dcm_locked),        
        .wr_clk(clkout320),  
        .wr_en(~fifo_full),    
        .din({q_data, i_data}),        
        .full(fifo_full),      
        .rd_clk(clkin320),  
        .rd_en(~fifo_empty),    
        .dout({q_out, i_out}),      
        .empty(fifo_empty) );

endmodule

