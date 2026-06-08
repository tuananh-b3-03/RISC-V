module axi4_ram #
(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,
    parameter ID_WIDTH   = 4
)
(
    input                         clk,
    input                         resetn,

    input      [ID_WIDTH-1:0]     s_axi_awid,
    input      [ADDR_WIDTH-1:0]   s_axi_awaddr,
    input      [7:0]              s_axi_awlen,
    input      [2:0]              s_axi_awsize,
    input      [1:0]              s_axi_awburst,
    input                         s_axi_awvalid,
    output reg                    s_axi_awready,

    input      [DATA_WIDTH-1:0]   s_axi_wdata,
    input      [DATA_WIDTH/8-1:0] s_axi_wstrb,
    input                         s_axi_wlast,
    input                         s_axi_wvalid,
    output reg                    s_axi_wready,

    output reg [ID_WIDTH-1:0]     s_axi_bid,
    output reg [1:0]              s_axi_bresp,
    output reg                    s_axi_bvalid,
    input                         s_axi_bready,

    input      [ID_WIDTH-1:0]     s_axi_arid,
    input      [ADDR_WIDTH-1:0]   s_axi_araddr,
    input      [7:0]              s_axi_arlen,
    input      [2:0]              s_axi_arsize,
    input      [1:0]              s_axi_arburst,
    input                         s_axi_arvalid,
    output reg                    s_axi_arready,

    output reg [ID_WIDTH-1:0]     s_axi_rid,
    output reg [DATA_WIDTH-1:0]   s_axi_rdata,
    output reg [1:0]              s_axi_rresp,
    output reg                    s_axi_rlast,
    output reg                    s_axi_rvalid,
    input                         s_axi_rready
);

    localparam STRB_WIDTH = DATA_WIDTH / 8;
    localparam WORD_ADDR_WIDTH = ADDR_WIDTH - 2;
    localparam WORDS = 1 << WORD_ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] mem [0:WORDS-1];

    reg [ID_WIDTH-1:0] write_id;
    reg [ADDR_WIDTH-1:0] write_addr;
    reg [7:0] write_count;
    reg [1:0] write_burst;
    reg write_active;

    reg [ID_WIDTH-1:0] read_id;
    reg [ADDR_WIDTH-1:0] read_addr;
    reg [7:0] read_count;
    reg [1:0] read_burst;
    reg read_active;

    integer i;
    integer j;

    initial begin
        for (i = 0; i < WORDS; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}};
        end
    end

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            s_axi_awready <= 1'b1;
            s_axi_wready  <= 1'b0;
            s_axi_bid     <= {ID_WIDTH{1'b0}};
            s_axi_bresp   <= 2'b00;
            s_axi_bvalid  <= 1'b0;
            write_id      <= {ID_WIDTH{1'b0}};
            write_addr    <= {ADDR_WIDTH{1'b0}};
            write_count   <= 8'd0;
            write_burst   <= 2'b00;
            write_active  <= 1'b0;
        end else begin
            if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 1'b0;
                s_axi_awready <= 1'b1;
            end

            if (s_axi_awready && s_axi_awvalid) begin
                write_id     <= s_axi_awid;
                write_addr   <= s_axi_awaddr;
                write_count  <= s_axi_awlen;
                write_burst  <= s_axi_awburst;
                write_active <= 1'b1;
                s_axi_awready <= 1'b0;
                s_axi_wready  <= 1'b1;
            end

            if (s_axi_wready && s_axi_wvalid && write_active) begin
                for (j = 0; j < STRB_WIDTH; j = j + 1) begin
                    if (s_axi_wstrb[j]) begin
                        mem[write_addr >> 2][j*8 +: 8] <= s_axi_wdata[j*8 +: 8];
                    end
                end

                if (write_burst == 2'b01) begin
                    write_addr <= write_addr + (1 << s_axi_awsize);
                end

                if (s_axi_wlast || write_count == 8'd0) begin
                    write_active <= 1'b0;
                    s_axi_wready <= 1'b0;
                    s_axi_bid    <= write_id;
                    s_axi_bresp  <= 2'b00;
                    s_axi_bvalid <= 1'b1;
                end else begin
                    write_count <= write_count - 8'd1;
                end
            end
        end
    end

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            s_axi_arready <= 1'b1;
            s_axi_rid     <= {ID_WIDTH{1'b0}};
            s_axi_rdata   <= {DATA_WIDTH{1'b0}};
            s_axi_rresp   <= 2'b00;
            s_axi_rlast   <= 1'b0;
            s_axi_rvalid  <= 1'b0;
            read_id       <= {ID_WIDTH{1'b0}};
            read_addr     <= {ADDR_WIDTH{1'b0}};
            read_count    <= 8'd0;
            read_burst    <= 2'b00;
            read_active   <= 1'b0;
        end else begin
            if (s_axi_arready && s_axi_arvalid) begin
                read_id       <= s_axi_arid;
                read_addr     <= s_axi_araddr;
                read_count    <= s_axi_arlen;
                read_burst    <= s_axi_arburst;
                read_active   <= 1'b1;
                s_axi_arready <= 1'b0;
                s_axi_rid     <= s_axi_arid;
                s_axi_rdata   <= mem[s_axi_araddr >> 2];
                s_axi_rresp   <= 2'b00;
                s_axi_rlast   <= (s_axi_arlen == 8'd0);
                s_axi_rvalid  <= 1'b1;
            end else if (s_axi_rvalid && s_axi_rready) begin
                if (s_axi_rlast) begin
                    s_axi_rvalid  <= 1'b0;
                    s_axi_rlast   <= 1'b0;
                    s_axi_arready <= 1'b1;
                    read_active   <= 1'b0;
                end else begin
                    if (read_burst == 2'b01) begin
                        read_addr <= read_addr + (1 << s_axi_arsize);
                        s_axi_rdata <= mem[(read_addr + (1 << s_axi_arsize)) >> 2];
                    end else begin
                        s_axi_rdata <= mem[read_addr >> 2];
                    end

                    if (read_count == 8'd1) begin
                        s_axi_rlast <= 1'b1;
                    end

                    read_count <= read_count - 8'd1;
                    s_axi_rid <= read_id;
                    s_axi_rresp <= 2'b00;
                    read_active <= 1'b1;
                end
            end
        end
    end
endmodule
