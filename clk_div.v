module clk_div_n #(
    parameter N = 5 // 參數化被除數
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_out
);

    // 計算計數器所需的位元數
    // 例如 N=3, 需要 2 bits; N=100, 需要 7 bits
    localparam WIDTH = $clog2(N);

    reg [WIDTH-1:0] pos_count;
    reg [WIDTH-1:0] neg_count;

    // 1. 上升沿計數器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pos_count <= 0;
        else if (pos_count == N-1)
            pos_count <= 0;
        else
            pos_count <= pos_count + 1;
    end

    // 2. 下降沿計數器 (邏輯與上升沿相同)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            neg_count <= 0;
        else if (neg_count == N-1)
            neg_count <= 0;
        else
            neg_count <= neg_count + 1;
    end

    // 3. 輸出邏輯
    // 如果 N 是偶數，輸出就是 (pos_count < N/2)
    // 如果 N 是奇數，輸出則是 (pos_count < N/2) | (neg_count < N/2) 的變體
    // 這裡使用通用公式來達成 50% 佔空比
    assign clk_out = (N == 1) ? clk :           // 不除頻
      (N[0] == 0) ? (pos_count < N>>1) : // 偶數：只看上升沿即可 (50%)
      (pos_count < N>>1) | (neg_count < N>>1); // 奇數

endmodule
