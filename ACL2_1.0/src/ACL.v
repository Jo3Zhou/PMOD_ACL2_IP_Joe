//PMOD ACL2
//Author: Joe
//15.07.22

module ACL(
    input clk,
    input rstn,
    
    input load,
    
    output reg cs,
    output reg sck,
    output reg mosi,
    input miso,
    
    input [7:0] winstr,
    input [7:0] waddr,
    input [7:0] wdata,
    output reg [7:0] rdata
    
    );
    
    parameter idle =  0;
    parameter instr_w =  2;
    parameter addr_w =  3;
    parameter data_w =  4;
    parameter data_r =  5;
    parameter ending = 6;

    reg [2:0] state, next_state;
    
    reg en_cnt;
    reg [2:0] cnt = 3'd7;

    reg [7:0] rdata_int;
    
    always @(negedge clk) begin //spi_clk
        if (rstn == 1'b0) begin
            cnt <= 3'd0;
        end
        else begin
            if (en_cnt) begin
                cnt <= cnt - 1;
            end
            else begin
                cnt <= cnt;
            end
        end
    end

    always @(negedge clk) begin
        if (rstn == 1'b0) begin
            state <= idle;
        end 
        else begin
            state <= next_state;
        end
    end 
    
    always @(*) begin
        case (state)
            idle: begin
                if (load == 1'b1) begin
                    next_state = instr_w;
                end 
                else begin
                    next_state = state;
                end
             end
             instr_w: begin
                if (cnt == 3'd0) begin
                    next_state = addr_w;
                end
                else begin
                    next_state = state;
                end 
             end
             addr_w: begin
                if (cnt == 3'd0) begin
                    case (winstr)
                        7'b00001011: begin
                            next_state = data_r;
                        end
                        7'b00001010: begin
                            next_state = data_w;
                        end
                    endcase
                end
                else begin
                    next_state = state;
                end
            end
            data_r: begin
                if (cnt == 3'd0) begin
                    next_state = ending;
                end
                else begin
                    next_state = state;
                end
            end
            data_w: begin
                if (cnt == 3'd0) begin
                    next_state = ending;
                end
                else begin
                    next_state = state;
                end
            end
            ending: begin
                if (cnt == 3'd0) begin
                    next_state = idle;
                end
                else begin
                    next_state = state;
                end
            end
        endcase
    end
            
    always @(*) begin
        case (state)
            idle: begin
                cs = 1'b1;
                sck = 1'b0;
                en_cnt = 1'b0;
                mosi = 1'd0;
                rdata = rdata;
                
            end
            instr_w: begin
                cs = 1'b0;
                sck = clk;  //spi_clk
                en_cnt = 1'b1;
                mosi = winstr[cnt];
                rdata = rdata;
            end
            addr_w: begin
                cs = 1'b0;
                sck = clk;
                en_cnt = 1'b1;
                mosi = waddr[cnt];
                rdata = rdata;
            end
            data_r: begin
                cs = 1'b0;
                sck = clk;
                en_cnt = 1'b1;
                mosi = 1'b0;
                rdata = rdata;
            end
            data_w: begin
                cs = 1'b0;
                sck = clk;
                en_cnt = 1'b1;
                mosi = wdata[cnt];
                rdata = rdata;
            end
            ending: begin
                cs = 1'b1;
                sck = clk;
                en_cnt = 1'b1;
                mosi = 1'b0;
                rdata = rdata_int;
            end
       endcase
    end
   
    always @(posedge clk) begin
        if (state == data_r) begin
            rdata_int[cnt] = miso;
        end
        else begin
            rdata_int = rdata;
        end
    end 
           

endmodule
