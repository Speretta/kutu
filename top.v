module top (input clk_i,
            input rst_i);
    
    wire [31:0] buyruk;
    wire [31:0] buyruk_adres;
    
    kutu kutu1 (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .buyruk_i(buyruk),
    .buyruk_adres_o(buyruk_adres)
    );
    
    bellek bellek1 (
    .clk_i(clk_i),
    .wen_i(1'b0),
    .adres_i(buyruk_adres),
    .veri_i(32'b0),
    .veri_o(buyruk)
    );
    
endmodule
