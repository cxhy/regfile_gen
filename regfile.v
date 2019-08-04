module regfile
#(
  parameter GPIO0_CRL_ADDR = 32'h0,
  parameter GPIO0_CRH_ADDR = 32'h4,

  parameter WDATA_WIDTH = 32,
  parameter RDATA_WIDTH = 32,
  parameter ADDR_WIDTH  = 32
)
(
  //system ports
  clk,
  reset_n,

  //regfile ports
  cnf7,
  mode7,
  cnf6,
  mode6,


  //bus ports
  reg_wdata[WDATA_WIDTH-1:0],
  reg_rdata[RDATA_WIDTH-1:0],
  reg_addr[ADDR_WIDTH-1:0],
  reg_en,
  reg_we
);

always @ (posedge clk or negedge reset_n)begin:PROC_WE_GPIO0_CRL
  if(reset_n == 1'b0)
    we_gpio0_crl <= 1'b0;
  else if((reg_addr[2:0] == reg_addr[2:0]) && (reg_en) && reg_we)
    we_gpio0_crl <= 1'b1;
  else
    we_gpio0_crl <= 1'b0;
end

always @ (posedge clk or negedge reset_n)begin:PROC_RD_GPIO0_CRL
  if(reset_n == 1'b0)
    re_gpio0_crl <= 1'b0;
  else if((reg_addr[2:0] == GPIO0_CRL_ADDR) && (reg_en) && (~reg_we))
    re_gpio0_crl <= 1'b1;
  else
    re_gpio0_crl <= 1'b0;
end

always @ (posedge clk or negedge reset_n)begin:PROC_RDATA
  if(reset_n == 1'b0)begin
    cnf7[1:0]  <= 2'h0;
    mode7[1:0] <= 2'h0;
    cnf6[1:0]  <= 2'h0;
    mode6[1:0] <= 2'h0;
    cnf5[1:0]  <= 2'h0;
    mode5[1:0] <= 2'h0;
    cnf4[1:0]  <= 2'h0;
    mode4[1:0] <= 2'h0;
    cnf3[1:0]  <= 2'h0;
    mode3[1:0] <= 2'h0;
    cnf2[1:0]  <= 2'h0;
    mode2[1:0] <= 2'h0;
    cnf1[1:0]  <= 2'h0;
    mode1[1:0] <= 2'h0;
    cnf0[1:0]  <= 2'h0;
    mode0[1:0] <= 2'h0;
  end
  else if(we_gpio0_crl)begin
    cnf7[1:0]  <= reg_wdata[31:30];
    mode7[1:0] <= reg_wdata[29:28];
    cnf6[1:0]  <= reg_wdata[27:26];
    mode6[1:0] <= reg_wdata[25:24];
    cnf5[1:0]  <= reg_wdata[23:22];
    mode5[1:0] <= reg_wdata[21:20];
    cnf4[1:0]  <= reg_wdata[19:18];
    mode4[1:0] <= reg_wdata[17:16];
    cnf3[1:0]  <= reg_wdata[15:14];
    mode3[1:0] <= reg_wdata[13:12];
    cnf2[1:0]  <= reg_wdata[11:10];
    mode2[1:0] <= reg_wdata[9:8];
    cnf1[1:0]  <= reg_wdata[7:6];
    mode1[1:0] <= reg_wdata[5:4];
    cnf0[1:0]  <= reg_wdata[3:2];
    mode0[1:0] <= reg_wdata[1:0];
  end
end


always @ (*)begin
  reg_rdata_tmp[RDATA_WIDTH-1:0] = {RDATA_WIDTH{1'b0}};
  case(reg_addr[2:0])
    GPIO0_CRL_ADDR : reg_rdata_tmp[RDATA_WIDTH-1:0] = {cnf7[1:0],mode7[1:0],cnf6[1:0],mode6[1:0],cnf5[1:0],mode5[1:0],cnf4[1:0],mode4[1:0],cnf3[1:0],mode3[1:0],cnf2[1:0],mode2[1:0],cnf1[1:0],mode1[1:0],cnf0[1:0],mode0[1:0]};
    default        : reg_rdata_tmp[RDATA_WIDTH-1:0] = {RDATA_WIDTH{1'b0}};
  endcase
end

assign reg_rdata[RDATA_WIDTH-1:0] = reg_rdata[RDATA_WIDTH-1:0];

endmodule


module auto_clear
#(
  parameter WIDTH = 1
)(
  clk,
  reset_n,
  set,
  clear,
  reg_out
);

input                clk;
input                reset_n;
input    [WIDTG-1:0] set;
input    [WIDTH-1:0] clear;
output   [WIDTH-1:0] reg_out;

always @ (posedge clk or negedge reset_n)begin
  if(reset_n == 1'b0)
    set_dly[WIDTH-1:0] <= WIDTH'b0;
  else
    set_dly[WIDTH-1:0] <= set[WIDTH-1:0];
end

assign set_tog[WIDTH-1:0] =   set[WIDTH-1:0]  & (~set_dly[WIDTH-1:0]);
assign clr_tog[WIDTH-1:0] = (~clr[WIDTH-1:0]) &   reg_out[WIDTH-1:0];

assign reg_in[WIDTH-1:0]  = set_tog[WIDTH-1:0] | clr_tog[WIDTH-1:0];

always @ (posedge clk or negedge reset_n)begin
  if(reset_n == 1'b0)
    reg_out[WIDTH-1:0] <= WIDTH'b0;
  else
    reg_out[WIDTH-1:0] <= reg_in[WIDTH-1:0];
end
endmodule

