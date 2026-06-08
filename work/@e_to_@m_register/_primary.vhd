library verilog;
use verilog.vl_types.all;
entity E_to_M_register is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        RegWriteE       : in     vl_logic;
        ResultSrcE      : in     vl_logic_vector(1 downto 0);
        MemWriteE       : in     vl_logic;
        ALU_outE        : in     vl_logic_vector(31 downto 0);
        WriteDataE      : in     vl_logic_vector(31 downto 0);
        write_addrE     : in     vl_logic_vector(4 downto 0);
        PC_plus4E       : in     vl_logic_vector(31 downto 0);
        ALU_outM        : out    vl_logic_vector(31 downto 0);
        WriteDataM      : out    vl_logic_vector(31 downto 0);
        write_addrM     : out    vl_logic_vector(4 downto 0);
        PC_plus4M       : out    vl_logic_vector(31 downto 0);
        RegWriteM       : out    vl_logic;
        ResultSrcM      : out    vl_logic_vector(1 downto 0);
        MemWriteM       : out    vl_logic
    );
end E_to_M_register;
