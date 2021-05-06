module xst_ram_1r1w_synch_8_4_0 (input wire  clk, reset, w_wr, input wire [0:3] w_din, input wire [0:2] w_addr, r_addr, output wire [0:3] r_dout);
  wire [0:2] wa,ra; reg [0:2] _wa,_ra; wire [0:3] wi,wo,ro;
  reg [0:3] ram [0:7];
  // 4 bits words, 8 such words
  integer i;
  initial begin
    for (i=0;i<8;i=i+1) ram[i]=0;
    ram[3'h0]=4'h0;
  end
  always @(posedge clk) begin if (w_wr) ram[wa]<=wi; _wa<=wa; _ra<=ra; end
  assign wa = w_addr[0:2];
  assign ra = r_addr[0:2];
  assign wi = w_din[0:3];
  assign r_dout[0:3] = ram [_ra];
endmodule
// this is a 4-bit input to a ram which has 8 address locations(therefore  3-bits of reference)

/*
  initial begin
    for (i=0;i<8;i=i+1) ram[i]=0;
    ram[3'h0]=4'h0;
  end
  always @(posedge clk) begin if (w_wr) ram[wa]<=wi; _wa<=wa; _ra<=ra; end
  assign wa = w_addr[0:2];
  assign ra = r_addr[0:2];
  assign wi = w_din[0:3];
  assign r_dout[0:3] = ram [_ra];
endmodule
*/
