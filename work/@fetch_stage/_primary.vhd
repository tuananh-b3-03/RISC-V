library verilog;
use verilog.vl_types.all;
entity Fetch_stage is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        StallF          : in     vl_logic;
        PCTargetE       : in     vl_logic_vector(31 downto 0);
        PCSrcE          : in     vl_logic;
        PC_next         : out    vl_logic_vector(31 downto 0);
        Instr           : out    vl_logic_vector(31 downto 0);
        PC_now          : out    vl_logic_vector(31 downto 0);
        PC_plus4        : out    vl_logic_vector(31 downto 0)
    );
end Fetch_stage;
