
`timescale 1ns / 1ps

module tb_clk_div3();

    reg clk;
    reg rst_n;
    wire clk_out;

    // 實例化被測元件 (DUT)
  clk_div_n # (.N(3)) dut (
        .clk(clk),
      	.rst_n(rst_n),
        .clk_out(clk_out)
    );

    // 產生時脈：10ns 週期 (100MHz)
    always #5 clk = ~clk;

    initial begin
        // 準備輸出波形檔 (VCD 格式)
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_clk_div3);

        // 初始化訊號
        clk = 0;
        rst_n = 0;

        // 釋放重置
        #20 rst_n = 1;

        // 模擬運行一段時間
        #200;

        $display("Simulation Finished");
        $finish;
    end

endmodule
