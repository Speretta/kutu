module gc_kaydedici(input clk_i,                   // Clock girdisi
                   input rst_i,                   // Reset sinyali girdisi
                   input [31:0] buyruk_g_i,       // Bellekten gelen buyruk sinyali
                   output reg [31:0] buyruk_c_o); // Boru hattı çözücüsüne giden sinyaş
    
    // Clock ve Reset sinyali pozitif kenarı ile senkron
    always @(posedge clk_i, posedge rst_i) begin
        if (rst_i) begin
            buyruk_c_o <= 32'b0; // Çözücü sinyali sıfırlandı
        end
        else begin
            buyruk_c_o <= buyruk_g_i; // Bellekten gelen buyruk sinyali çözücüye aktarıldı
        end
    end
endmodule
