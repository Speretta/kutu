module amb(input amb_secim_i,                // Aritmetik işlemler için 2. ifade rs2 mi yoksa bir sabit(ivedi) değer mi
           input [3:0] amb_fonksiyon_i,      // İşlem seçim sinyali
           input [31:0] reg_a_i,             // rs1 değeri
           input [31:0] reg_b_i,             // rs2 değeri
           input [31:0] sabit_genisletici_i, // imm değeri
           output reg [31:0] amb_cikis_o);   // sonuç değeri
    
    
    // İşlenen buyruk sabit içerse de içermese de ilk ifade her zaman bir register
    wire signed [31:0] amb_a = reg_a_i;
    
    // Seçim sinyali ile MUX yapıldı, sinyale göre ikinci ifade sabit veya rs2 olarak seçildi
    wire signed [31:0] amb_b = amb_secim_i ? sabit_genisletici_i : reg_b_i;
    
    always @(*) begin
        case (amb_fonksiyon_i)
            4'b0000  : amb_cikis_o = amb_a + amb_b;  // Toplama
            4'b0001  : amb_cikis_o = amb_a - amb_b;  // Çıkarma
            4'b0010  : amb_cikis_o = amb_a & amb_b;  // VE
            4'b0011  : amb_cikis_o = amb_a ^ amb_b;  // XOR
            4'b0100  : amb_cikis_o = amb_a | amb_b;  // VEYA
            default  : amb_cikis_o = 32'bx;          // Geçersiz alu_fun_i sinyali
        endcase
    end
    
endmodule
