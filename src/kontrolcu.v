module kontrolcu(input [31:0] buyruk_i,                   // Boru hattı kaydedicisinden gelen buyruk
                 output regfile_wen_o,                    // Yazma yetkilendirme çıktısı
                 output [2:0] sabit_genisletici_secimi_o, // İvedi genişletici format seçimi çıkışı
                 output amb_secim_o,                      // AMB ikinci işlenen ifade sabit mi rs2 mi sinyali
                 output reg [3:0] amb_fonksiyon_o);       // AMB fonksiyon seçim sinyali


// Buyruğun bölümleri ayıklanıyor
wire [6:0] opcode = buyruk_i[6:0];
wire [2:0] funct3 = buyruk_i[14:12];
wire [6:0] funct7 = buyruk_i[31:25];

wire [1:0] amb_cozucu;

reg [6:0] control_sinyalleri;
assign {regfile_wen_o, sabit_genisletici_secimi_o, amb_secim_o, amb_cozucu} = control_sinyalleri;

always @(*) begin
    case (opcode)
        7'b0110011  : control_sinyalleri = 7'b1_xxx_0_11; // R-type buyruk
        7'b0010011  : control_sinyalleri = 7'b1_000_1_11; // I-type buyruk
        7'b0000000  : control_sinyalleri = 7'b0_000_0_00; // Sıfırlama durumu
        default     : control_sinyalleri = 7'bx_xxx_x_xx; // Geçersiz buyruk
    endcase
end

// Aritmetik Mantık Biriminde Yapılacak işlemler belirleniyor
always @(*) begin
    case (amb_cozucu)
        2'b11    : // R-type veya I-type
        case (funct3)
            3'b000   : // add-addi veya sub buyruğu
            // Buyruk R-type ise ve funct7 değeri 0x20 ise çıkarma işlemi yapılacaktır
            if (opcode[5] & funct7[5]) begin
                amb_fonksiyon_o = 4'b0001; // sub
                end else begin
                    amb_fonksiyon_o = 4'b0000; // add, addi
                end
                3'b100   : amb_fonksiyon_o = 4'b0011; // xor, xori
                3'b110   : amb_fonksiyon_o = 4'b0100; // or, ori
                3'b111   : amb_fonksiyon_o = 4'b0010; // and, andi
                default  : amb_fonksiyon_o = 4'b0000;
        endcase
        default  : amb_fonksiyon_o = 4'b0000; // Varsayılan işlemi toplama olarak belirledik.
    endcase
end

endmodule
