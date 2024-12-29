module cozucu(input clk_i,                            // Clock girdisi
              input regfile_wen_i,                    // Yazma yetkilendirme girdisi
              input [2:0] sabit_genisletici_secimi_i, // İvedi genişletici format seçimi
              input [31:0] buyruk_i,                  // Boru hattı kaydedicisinden gelen buyruk
              input [31:0] sonuc_i,                   // Hedef kaydedicisine (rd) yazılacak değer
              output [31:0] reg_a_o,                  // Birinci kaynak kaydedicisinin (rs1) değeri
              output [31:0] reg_b_o,                  // İkinci kaynak kaydedicisinin (rs2) değeri
              output reg [31:0] sabit_genisletici_o); // İvedi genişleticinin çıkışı
    
    // 32 bit genişliğinde 32 adet kaydedici içeren kaydedici dosyası
    reg [31:0] reg_dosyasi [31:0];
    
    // Buyruk girdisini ayıklama
    wire [4:0] reg_a_adres     = buyruk_i[19:15]; // rs1'in adresi
    wire [4:0] reg_b_adres     = buyruk_i[24:20]; // rs2'nin adresi
    wire [4:0] hedef_reg_adres = buyruk_i[11:7]; // rd'nin adresi
    
    // rs1 ve rs2'nin değerleri kaydedici dosyadan okundu
    // Eğer adresleri 0 noktasını gösteriyorsa okunan değer 0 olarak kabul edildi
    // Esasında 0 adresi farklı değerler içerebilir ama RISC mimarisinde nop buyruğu için
    // Bu adres her zaman 0'a sahipmiş gibi davranılır
    assign reg_a_o = (reg_a_adres == 5'b0) ? 32'b0 : reg_dosyasi[reg_a_adres];
    assign reg_b_o = (reg_b_adres == 5'b0) ? 32'b0 : reg_dosyasi[reg_b_adres];
    
    // Kaydedici dosyasına yazıldı
    always @(posedge clk_i) begin
        if (regfile_wen_i) begin
            reg_dosyasi[hedef_reg_adres] <= sonuc_i;
        end
    end
    
    
    // Sabit(ivedi) genişletici
    // "addi" buyruğu sadece sayının 12 bit'lik kısmını işleyebiliyor
    // Daha sonra "li" buyruğu ile sayının geri kalan bitleri iletiliyor
    // Sadece "addi" buyruğu içeren durum için 12 bit'lik sayı 32 bit'e genişletildi
    always @(*) begin
        case (sabit_genisletici_secimi_i)
            // 12 bitlik sayı 32 bit'e çevrildi
            // Bu yapılırken kalan kısımlar 0 ile doldurulmak yerine 12 bitlik sayının imza biti ile dolduruldu
            // Bu sayede verinin işareti(pozitif/negatif) kaybolmamış oldu
            3'b000   : sabit_genisletici_o = {{20{buyruk_i[31]}}, buyruk_i[31:20]};
            default  : sabit_genisletici_o = 32'b0;
        endcase
    end
    
endmodule
