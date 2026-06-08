library verilog;
use verilog.vl_types.all;
entity M_to_W_register is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        RegWriteM       : in     vl_logic;
        ResultSrcM      : in     vl_logic_vector(1 downto 0);
        ALU_outM        : in     vl_logic_vector(31 downto 0);
        ReadDataM       : in     vl_logic_vector(31 downto 0);
        write_addrM     : in     vl_logic_vector(4 downto 0);
        PC_plus4M       : in     vl_logic_vector(31 downto 0);
        ALU_outW        : out    vl_logic_vector(31 downto 0);
        ReadDataW       : out    vl_logic_vector(31 downto 0);
        write_addrW     : out    vl_logic_vector(4 downto 0);
        PC_plus4W       : out    vl_logic_vector(31 downto 0);
        RegWriteW       : out    vl_logic;
        ResultSrcW      : out    vl_logic_vector(1 downto 0)
    );
end M_to_W_register;
