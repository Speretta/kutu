module kutu(input clk_i,                    // Clock girdisi
            input rst_i,                    // Reset sinyali girdisi
            input [31:0] buyruk_i,          // Bellekten gelen buyruk
            output [31:0] buyruk_adres_o); // Belleğe giden buyruk adresi
    
    getir getir1(.clk_i(clk_i),
    .rst_i(rst_i),
    .pc_o(buyruk_adres_o));
    
    // Boru hattı kaydedicisi bağlantıları
    wire [31:0] getir_2_cozucu_buyruk;
    gc_kaydedici gc_kaydedici1(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .buyruk_g_i(buyruk_i),
    .buyruk_c_o(getir_2_cozucu_buyruk)
    );
    
    // Çözücü modülü bağlantıları
    wire c2d_regfile_wen;
    wire [2:0] c2d_imm_ext_sel;
    wire [31:0] w2d_result;
    wire [31:0] d2a_reg_a;
    wire [31:0] d2a_reg_b;
    wire [31:0] d2a_imm_ext;
    
    cozucu cozucu1(
    .clk_i(clk_i),
    .regfile_wen_i(c2d_regfile_wen),
    .sabit_genisletici_secimi_i(c2d_imm_ext_sel),
    .buyruk_i(getir_2_cozucu_buyruk),
    .sonuc_i(w2d_result),
    .reg_a_o(d2a_reg_a),
    .reg_b_o(d2a_reg_b),
    .sabit_genisletici_o(d2a_imm_ext)
    );
    
    // Aritmetik Mantık Birimi bağlantıları
    wire c2a_alu_sel;
    wire [3:0] c2a_alu_fun;
    wire [31:0] a2w_alu_out;
    
    amb amb1 (
    .amb_secim_i(c2a_alu_sel),
    .amb_fonksiyon_i(c2a_alu_fun),
    .reg_a_i(d2a_reg_a),
    .reg_b_i(d2a_reg_b),
    .sabit_genisletici_i(d2a_imm_ext),
    .amb_cikis_o(a2w_alu_out)
    );
    
    geri_yazma geri_yazma1 (
    .amb_cikis_i(a2w_alu_out),
    .sonuc_o(w2d_result)
    );
    
    kontrolcu kontrolcu1 (
    .buyruk_i(getir_2_cozucu_buyruk),
    .regfile_wen_o(c2d_regfile_wen),
    .sabit_genisletici_secimi_o(c2d_imm_ext_sel),
    .amb_secim_o(c2a_alu_sel),
    .amb_fonksiyon_o(c2a_alu_fun)
    );
endmodule
