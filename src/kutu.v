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
    wire kontrolcu_2_cozucu_regfile_wen;
    wire [2:0] kontrolcu_2_sabit_genisletici_secimi;
    wire [31:0] geriyazma_2_cozucu_sonuc;
    wire [31:0] cozucu_2_amb_reg_a;
    wire [31:0] cozucu_2_amb_reg_b;
    wire [31:0] cozucu_2_sabit_genisletici_o;
    
    cozucu cozucu1(
    .clk_i(clk_i),
    .regfile_wen_i(kontrolcu_2_cozucu_regfile_wen),
    .sabit_genisletici_secimi_i(kontrolcu_2_sabit_genisletici_secimi),
    .buyruk_i(getir_2_cozucu_buyruk),
    .sonuc_i(geriyazma_2_cozucu_sonuc),
    .reg_a_o(cozucu_2_amb_reg_a),
    .reg_b_o(cozucu_2_amb_reg_b),
    .sabit_genisletici_o(cozucu_2_sabit_genisletici_o)
    );
    
    // Aritmetik Mantık Birimi bağlantıları
    wire kontrolcu_2_amb_secim;
    wire [3:0] kontrolcu_2_amb_fonksiyon;
    wire [31:0] amb_2_geriyazma_cikis;
    
    amb amb1 (
    .amb_secim_i(kontrolcu_2_amb_secim),
    .amb_fonksiyon_i(kontrolcu_2_amb_fonksiyon),
    .reg_a_i(cozucu_2_amb_reg_a),
    .reg_b_i(cozucu_2_amb_reg_b),
    .sabit_genisletici_i(cozucu_2_sabit_genisletici_o),
    .amb_cikis_o(amb_2_geriyazma_cikis)
    );
    
    geriyazma geriyazma1 (
    .amb_cikis_i(amb_2_geriyazma_cikis),
    .sonuc_o(geriyazma_2_cozucu_sonuc)
    );
    
    kontrolcu kontrolcu1 (
    .buyruk_i(getir_2_cozucu_buyruk),
    .regfile_wen_o(kontrolcu_2_cozucu_regfile_wen),
    .sabit_genisletici_secimi_o(kontrolcu_2_sabit_genisletici_secimi),
    .amb_secim_o(kontrolcu_2_amb_secim),
    .amb_fonksiyon_o(kontrolcu_2_amb_fonksiyon)
    );
endmodule
