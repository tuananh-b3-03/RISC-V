library verilog;
use verilog.vl_types.all;
entity Control_Unit is
    port(
        opcode          : in     vl_logic_vector(6 downto 0);
        funct3          : in     vl_logic_vector(2 downto 0);
        funct7          : in     vl_logic_vector(6 downto 0);
        UIPC_add        : out    vl_logic;
        JumpR           : out    vl_logic;
        jump            : out    vl_logic;
        branch          : out    vl_logic;
        RegWrite        : out    vl_logic;
        MemWrite        : out    vl_logic;
        ALUSrc          : out    vl_logic;
        resultSrc       : out    vl_logic_vector(1 downto 0);
        ALUCtrl         : out    vl_logic_vector(4 downto 0);
        ImmSrc          : out    vl_logic_vector(2 downto 0)
    );
end Control_Unit;
