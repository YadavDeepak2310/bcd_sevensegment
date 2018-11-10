`timescale 1ns / 1ps

module segmentdriver(
     input           clk_fpga, // clock_input
     input           reset,    // reset
     output[6:0]     OP,       // seven segment output
     output[7:0]     AN,       // eight seven segment enable output
     input [1:0]     SW        // swithces for testing
        );

parameter OPND1 = 32'hffff_ffff;
parameter OPND2 = 32'h3456_211f;
parameter RSLT = 32'h12345678;
         
parameter MAX_COUNT = 99999;
wire counter_enable;
reg[16:0] counter_1k;
reg[3:0] counter;
reg[3:0] count;
wire clk_1k;
reg[3:0] num;
reg[7:0] seg;

reg[6:0] seg0;
reg[6:0] seg1;
reg[6:0] seg2;
reg[6:0] seg3;

reg[6:0] seg4;
reg[6:0] seg5;
reg[6:0] seg6;
reg[6:0] seg7;

reg[3:0] dtem0;

reg [31:0] disp;

reg[6:0] out;

reg[6:0] out_temp;

always @( posedge clk_fpga )
    if (counter_1k == MAX_COUNT)
       counter_1k <= 0;
    else
       counter_1k <= counter_1k + 1'b1;
       
  assign counter_enable = counter_1k == 0;
  
always @ ( posedge clk_fpga )
    if ( counter_enable )
    if ( counter == 1 )
       counter <= 0;
    else 
       counter <= counter + 1'b1;
       
  assign clk_1k = counter == 1;

always @(SW) begin
            case(SW)
                2'b00 : disp = OPND1;
                2'b01 : disp = OPND2;
                2'b10 : disp = RSLT;
                default : disp = RSLT;
             endcase
             end
 
always @ ( posedge clk_1k )
     if ( count == 8 )
       count <= 0;
     else 
       case ( count ) 
                   0 : begin
                        seg <= 8'b11111110;
                        dtem0 <= disp[3:0];
                        seg0 <= out_temp;
                        out <= seg0;
                        count <= count + 1;
                        end
                   1 : begin
                        seg <= 8'b11111101;
                        dtem0 <= disp[7:4];
                        seg1 <= out_temp;
                        out <= seg1;
                        count <= count + 1;
                        end
                   2 : begin
                        seg <= 8'b11111011;
                        dtem0 <= disp[11:8];
                        seg2 <= out_temp;
                        out <= seg2;
                        count <= count + 1;
                        end
                   3 : begin
                        seg <= 8'b11110111;
                        dtem0 <= disp[15:12];
                        seg3 <= out_temp;
                        out <= seg3;
                        count <= count + 1;
                        end
                   4 : begin
                        seg <= 8'b11101111;
                        dtem0 <= disp[19:16];
                        seg4 <= out_temp;
                        out <= seg4;
                        count <= count + 1;
                        end
                   5 : begin
                        seg <= 8'b11011111;
                        dtem0 <= disp[23:20];
                        seg5 <= out_temp;
                        out <= seg5;
                        count <= count + 1;
                        end
                   6 : begin
                        seg <= 8'b10111111;
                        dtem0 <= disp[27:24];
                        seg6 <= out_temp;
                        out <= seg6;
                        count <= count + 1;
                        end
                   7 : begin
                        seg <= 8'b01111111;
                        dtem0 <= disp[31:28];
                        seg7 <= out_temp;
                        out <= seg7;
                        count <= count + 1;
                        end                     
       endcase
 
 assign AN = seg;
 assign OP = out;

always @(dtem0) begin
                 case (dtem0)
                    4'b0000 : out_temp = 7'b100_0000;
                    4'b0001 : out_temp = 7'b111_1001;
                    4'b0010 : out_temp = 7'b010_0100;
                    4'b0011 : out_temp = 7'b011_0000;
                    4'b0100 : out_temp = 7'b001_1001;
                    4'b0101 : out_temp = 7'b001_0010;
                    4'b0110 : out_temp = 7'b000_0010;
                    4'b0111 : out_temp = 7'b111_1000;
                    4'b1000 : out_temp = 7'b000_0000;
                    4'b1001 : out_temp = 7'b001_1000;
                    4'b1010 : out_temp = 7'b000_1000;
                    4'b1011 : out_temp = 7'b000_0011;
                    4'b1100 : out_temp = 7'b100_0110;
                    4'b1101 : out_temp = 7'b010_0001;
                    4'b1110 : out_temp = 7'b000_0110;
                    4'b1111 : out_temp = 7'b000_1110;
                    default : out_temp = 7'b000_0000;
                 endcase
                 end

endmodule
        
        
