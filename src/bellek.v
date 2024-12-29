module bellek(input clk_i,           // Clock girdisi
              input wen_i,           // Yazma yetkilendirme girdisi
              input [31:0] adres_i,   // Okunacak veya yazılacak verinin adresi
              input [31:0] veri_i,   // Belleğe yazılacak veri
              output [31:0] veri_o); // Bellekten okunan veri
    
    // 512x32 bit = 16384 bit = 2048 bayt = 2 kibibayt (2 KiB)
    reg [31:0] mem [511:0];
    
    // program.mem okunup mem içerisine aktarıldı
    initial begin
        $readmemh("./programs/program.mem", mem);
    end

    // Clock'tan bağımsız asenkron okuma yapıldı
    assign veri_o = mem[adres_i[10:2]]; // Adresin en anlamsız 2 bitini kullanmadık ve 512 bit boyutunu adresleyebilecek şekilde kısalttık  adres_i[31:2]
    
    
    // Clock'la senkron olan yazma işlemi
    always @(posedge clk_i) begin
        if (wen_i) begin // Yazma yetkilendirilmesi yapıldıysa
            mem[adres_i[10:2]] <= veri_i; // Belleğe veri yazıldı ve 512 bit boyutunu adresleyebilecek şekilde kısalttık   adres_i[31:2]
        end
    end
    
endmodule
