library verilog;
use verilog.vl_types.all;
entity Decode_stage is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        RegWriteW       : in     vl_logic;
        RdW             : in     vl_logic_vector(4 downto 0);
        result          : in     vl_logic_vector(31 downto 0);
        InstrD          : in     vl_logic_vector(31 downto 0);
        PC_nowD         : in     vl_logic_vector(31 downto 0);
        PC_plus4D       : in     vl_logic_vector(31 downto 0);
        UIPC_add        : out    vl_logic;
        JumpR           : out    vl_logic;
        jump            : out    vl_logic;
        branch          : out    vl_logic;
        RegWrite        : out    vl_logic;
        MemWrite        : out    vl_logic;
        ALUSrc          : out    vl_logic;
        resultSrc       : out    vl_logic_vector(1 downto 0);
        ALUCtrl         : out    vl_logic_vector(4 downto 0);
        Read_data1      : out    vl_logic_vector(31 downto 0);
        Read_data2      : out    vl_logic_vector(31 downto 0);
        ImmExt          : out    vl_logic_vector(31 downto 0)
    );
end Decode_stage;
