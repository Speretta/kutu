module getir(input clk_i,             // Clock girdisi
             input rst_i,             // Sıfırlama sinyali girdisi
             output reg [31:0] pc_o); // Program sayacı
    
    // Clock ve Reset sinyali pozitif kenarı ile senkron
    always @(posedge clk_i, posedge rst_i) begin // Asenkron Reset sinyali daha iyi olabilir mi??
        if (rst_i) begin // Reset sinyali alındıysa
            pc_o <= 32'b0; // Program sayacını sıfırla
        end
        else begin
            pc_o <= pc_o + 4; // Reset sinyali yoksa clock sinyali ile program sayacını 4 arttır
        end
    end
    
endmodule
